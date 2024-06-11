{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper, imagemagick }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lsix";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "hackerb9";
    repo = "lsix";
    rev = finalAttrs.version;
    sha256 = "sha256-oa2+ADAJL3b57p4UF/0NT/WaM43TlsGXPVTtriczQbk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 lsix -t $out/bin

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/lsix \
      --prefix PATH : ${lib.makeBinPath [ (imagemagick.override { ghostscriptSupport = true;}) ]}
  '';

  meta = with lib; {
    description = "Shows thumbnails in terminal using sixel graphics";
    homepage = "https://github.com/hackerb9/lsix";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ justinlime kidonng ];
    mainProgram = "lsix";
  };
})
