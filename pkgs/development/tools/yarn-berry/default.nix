{ fetchFromGitHub, lib, nodejs, stdenv, yarn }:

stdenv.mkDerivation rec {
  name = "yarn-berry";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "yarnpkg";
    repo = "berry";
    rev = "@yarnpkg/cli/${version}";
    hash = "sha256-75bERA1uZeywMjYznFDyk4+AtVDLo7eIajVtWdAD/RA=";
  };

  buildInputs = [
    nodejs
  ];

  nativeBuildInputs = [
    yarn
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    yarn workspace @yarnpkg/cli build:cli
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm 755 ./packages/yarnpkg-cli/bundles/yarn.js "$out/bin/yarn"
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://yarnpkg.com/";
    description = "Fast, reliable, and secure dependency management.";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ryota-ka thehedgeh0g DimitarNestorov ];
    platforms = platforms.unix;
    mainProgram = "yarn";
  };
}
