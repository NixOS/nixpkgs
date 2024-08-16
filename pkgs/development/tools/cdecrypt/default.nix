{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "cdecrypt";
  version = "4.8";

  src = fetchFromGitHub {
    owner = "VitaSmith";
    repo = "cdecrypt";
    rev = "refs/tags/v${version}";
    hash = "sha256-PyT60RDyp1/Co/7WHC0+KrsnrDeTJ605x1pt4OmlGYg=";
  };

  installPhase = ''
    install -Dm755 cdecrypt $out/bin/cdecrypt
  '';

  meta = with lib; {
    description = "Utility that decrypts Wii U NUS content files";
    mainProgram = "cdecrypt";
    homepage = "https://github.com/VitaSmith/cdecrypt";
    changelog = "https://github.com/VitaSmith/cdecrypt/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hughobrien ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
