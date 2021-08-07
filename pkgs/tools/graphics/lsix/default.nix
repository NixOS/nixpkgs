{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper, imagemagick }:

stdenvNoCC.mkDerivation rec {
  pname = "lsix";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "hackerb9";
    repo = pname;
    rev = version;
    sha256 = "sha256-mOueSNhf1ywG4k1kRODBaWRjy0L162BAO1HRPaMMbFM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 lsix -t $out/bin

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/lsix \
      --prefix PATH : ${lib.makeBinPath [ imagemagick ]}
  '';

  meta = with lib; {
    description = "Shows thumbnails in terminal using sixel graphics";
    homepage = "https://github.com/hackerb9/lsix";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ kidonng ];
  };
}
