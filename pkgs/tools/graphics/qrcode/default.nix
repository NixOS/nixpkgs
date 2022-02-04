{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "qrcode";
  version = "unstable-2016-08-04";

  src = fetchFromGitHub {
    owner = "qsantos";
    repo = "qrcode";
    rev = "ad0fdb4aafd0d56b903f110f697abaeb27deee73";
    sha256 = "0v81745nx5gny2g05946k8j553j18a29ikmlyh6c3syq6c15k8cf";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/qrcode}
    cp qrcode "$out/bin"
    cp DOCUMENTATION LICENCE "$out/share/doc/qrcode"
  '';

  meta = with lib; {
    description = "A small QR-code tool";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; unix;
  };
}
