{
  fetchFromGitHub,
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "win-max-2-fan-control";
  version = "0-unstable-2023-02-16";

  src = fetchFromGitHub {
    hash = "sha256-rU0n+4glTWHWjbvbc7Se0O53g1mVDwBP5SkH4ftwNWk=";
    owner = "matega";
    repo = "win-max-2-fan-control";
    rev = "a9e65011e0b45d0a76fc5307ad2b7b585410dece";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 dist/Debug/GNU-Linux/winmax2fancontrol $out/bin/winmax2fancontrol
    runHook postInstall
  '';

  meta = with lib; {
    description = "Fan control for GPD Win Max 2 under Linux ";
    homepage = "https://github.com/matega/win-max-2-fan-control";
    license = licenses.gpl3;
    mainProgram = "winmax2fancontrol";
    maintainers = with maintainers; [ voronind ];
    platforms = platforms.linux;
  };
}
