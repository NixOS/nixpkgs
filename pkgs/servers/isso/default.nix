{ pkgs, nodejs, lib, python3Packages, fetchFromGitHub, nixosTests }:
let
  nodeEnv = import ./node-env.nix {
    inherit (pkgs) stdenv lib python2 runCommand writeTextFile;
    inherit pkgs nodejs;
    libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
  };
  nodePackages = import ./node-packages.nix {
    inherit (pkgs) fetchurl nix-gitignore stdenv lib fetchgit;
    inherit nodeEnv;
  };

  nodeDependencies = (nodePackages.shell.override (old: {
  })).nodeDependencies;
in
with python3Packages; buildPythonApplication rec {

  pname = "isso";
  version = "0.12.6.2";

  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-T5T3EJS8ef8uo+P9qkC+7I70qv+4PFrnhImr04Fz57U=";
  };

  propagatedBuildInputs = [
    itsdangerous
    jinja2
    misaka
    html5lib
    werkzeug
    bleach
    flask-caching
  ];

  nativeBuildInputs = [
    cffi
    nodejs
  ];

  preBuild = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
    export PATH="${nodeDependencies}/bin:$PATH"

    make js
  '';

  nativeCheckInputs = [
    pytest
    pytest-cov
  ];

  checkPhase = ''
    pytest
  '';

  passthru.tests = { inherit (nixosTests) isso; };

  meta = with lib; {
    description = "A commenting server similar to Disqus";
    homepage = "https://posativ.org/isso/";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz ];
  };
}
