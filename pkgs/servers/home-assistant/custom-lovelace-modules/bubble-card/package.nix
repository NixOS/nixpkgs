{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "bubble-card";
  version = "2.4.0";

  dontBuild = true;

  src = fetchFromGitHub {
    owner = "Clooos";
    repo = "Bubble-Card";
    rev = "v${version}";
    hash = "sha256-Hn6jH7lT+bjkOM/iRCmD1B8l6ZRqjNTmVMj4IN7ixE4=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -m0644 dist/bubble-card.js $out
    install -m0644 dist/bubble-pop-up-fix.js $out

    runHook postInstall
  '';

  meta = with lib; {
    changelog = "https://github.com/Clooos/bubble-card/releases/tag/v${version}";
    description = "Bubble Card is a minimalist card collection for Home Assistant with a nice pop-up touch.";
    homepage = "https://github.com/Clooos/Bubble-Card";
    license = licenses.mit;
    maintainers = with maintainers; [ pta2002 ];
  };
}
