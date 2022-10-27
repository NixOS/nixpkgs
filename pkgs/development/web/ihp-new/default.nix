{ lib, stdenv, fetchFromGitHub, git, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "ihp-new";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "digitallyinduced";
    repo = "ihp";
    rev = "v${version}";
    sha256 = "sha256-8RBZn74pMAOHZL1VzO9DeEeDYm5CE1HOobP9e7Ze0Us=";
  };

  dontConfigure = true;
  sourceRoot = "source/ProjectGenerator";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -Dm755 bin/ihp-new -t $out/bin
    wrapProgram $out/bin/ihp-new \
      --suffix PATH ":" "${lib.makeBinPath [ git ]}";
  '';

  meta = with lib; {
    description = "Project generator for the IHP (Integrated Haskell Platform) web framework";
    homepage = "https://ihp.digitallyinduced.com";
    license = licenses.mit;
    maintainers = [ maintainers.mpscholten ];
    platforms = platforms.unix;
  };
}
