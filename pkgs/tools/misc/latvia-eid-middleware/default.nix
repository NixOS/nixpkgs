{
  lib,
  stdenv,
  fetchurl,
  pkgs,
  autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "latvia-eid-middleware";
  version = "2.1.1";

  src = fetchurl {
    url = "https://www.eparaksts.lv/files/ep3updates/debian/pool/eparaksts/l/latvia-eid-middleware/latvia-eid-middleware_${version}-1_amd64.deb";
    sha256 = "sha256-k91y90INXeiRGm5ATW9k0094c72Yij23afSLGGRk0Lg=";
  };

  nativeBuildInputs = [
    pkgs.dpkg
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    at-spi2-atk
    glib
    gtk2
    gcc
    libGLU
    pcsclite
    xorg.libSM
    xorg.libXxf86vm
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./opt/latvia-eid/* $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Middleware for using Latvia-eid smart cards.";
    homepage = "https://www.pmlp.gov.lv";
    license = licenses.unfree;
    maintainers = with maintainers; [ vilsol ];
    platforms = platforms.linux;
  };
}
