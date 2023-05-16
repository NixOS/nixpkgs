<<<<<<< HEAD
{ pkgs, nodejs, lib, python3Packages, fetchFromGitHub, nixosTests, fetchNpmDeps, npmHooks }:

with python3Packages;

buildPythonApplication rec {
  pname = "isso";
  version = "0.13.0";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "posativ";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    sha256 = "sha256-kZNf7Rlb1DZtQe4dK1B283OkzQQcCX+pbvZzfL65gsA=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-RBpuhFI0hdi8bB48Pks9Ac/UdcQ/DJw+WFnNj5f7IYE=";
  };

  outputs = [
    "out"
    "doc"
  ];

=======
    sha256 = "sha256-T5T3EJS8ef8uo+P9qkC+7I70qv+4PFrnhImr04Fz57U=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    sphinxHook
    sphinx
    nodejs
    npmHooks.npmConfigHook
  ];

  NODE_PATH = "$npmDeps";

  preBuild = ''
    ln -s ${npmDeps}/node_modules ./node_modules
    export PATH="${npmDeps}/bin:$PATH"
=======
    nodejs
  ];

  preBuild = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
    export PATH="${nodeDependencies}/bin:$PATH"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
