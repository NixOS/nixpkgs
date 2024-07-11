{ fetchFromGitHub, lib, nodejs, stdenv, testers, yarn }:

stdenv.mkDerivation (finalAttrs: {
  pname = "yarn-berry";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "yarnpkg";
    repo = "berry";
    rev = "@yarnpkg/cli/${finalAttrs.version}";
    hash = "sha256-aV86k5gjHIbd09YDwC6aHA1tPl+p9Lt0cYVVvtNTDlY=";
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

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    homepage = "https://yarnpkg.com/";
    description = "Fast, reliable, and secure dependency management";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ryota-ka pyrox0 DimitarNestorov ];
    platforms = platforms.unix;
    mainProgram = "yarn";
  };
})
