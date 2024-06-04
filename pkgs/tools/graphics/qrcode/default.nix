{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "qrcode";
  version = "unstable-2023-12-02";

  src = fetchFromGitHub {
    owner = "qsantos";
    repo = "qrcode";
    rev = "96fac69ad3e4f616ce75c0e3ef4ed0574cfab315";
    hash = "sha256-Aesjys6FchB6qcLRWJNGfcEZRlO3stw3+IM8Xe2pF+Q=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/qrcode}
    cp qrcode "$out/bin"
    cp DOCUMENTATION LICENCE "$out/share/doc/qrcode"
  '';

  meta = with lib; {
    description = "A small QR-code tool";
    homepage = "https://github.com/qsantos/qrcode";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; unix;
    mainProgram = "qrcode";
  };
}
