{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "qrcode";
  version = "unstable-2022-01-10";

  src = fetchFromGitHub {
    owner = "qsantos";
    repo = "qrcode";
    rev = "f4475866bbf963ad118db936060f606eedc224d5";
    hash = "sha256-IbWYSAc0PvSWcxKaPUXDldGDCK/lPZjptepYtLppPmA=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

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
