{ stdenvNoCC
, lib
, fetchFromGitHub
, makeWrapper
, img2pdf
, zathura
}:

stdenvNoCC.mkDerivation {
  pname = "manga-cli";
  version = "unstable-2022-04-11";

  src = fetchFromGitHub {
    owner = "7USTIN";
    repo = "manga-cli";
    rev = "a69fe935341eaf96618a6b2064d4dcb36c8690b5";
    sha256 = "sha256-AnpOEgOBt2a9jtPNvfBnETGtc5Q1WBmSRFDvQB7uBE4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 manga-cli $out/bin/manga-cli

    wrapProgram $out/bin/manga-cli \
      --prefix PATH : ${lib.makeBinPath [ img2pdf zathura ]}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/7USTIN/manga-cli";
    description = "Bash script for reading mangas via the terminal by scraping manganato";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ baitinq ];
  };
}
