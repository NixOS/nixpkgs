{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "qrcode-git";
  version = "20160804";

  src = fetchFromGitHub {
    owner  = "qsantos";
    repo   = "qrcode";
    rev    = "ad0fdb4aafd0d56b903f110f697abaeb27deee73";
    sha256 = "0v81745nx5gny2g05946k8j553j18a29ikmlyh6c3syq6c15k8cf";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/qrcode}
    cp qrcode "$out/bin"
    cp DOCUMENTATION LICENCE "$out/share/doc/qrcode"
  '';

  meta = with stdenv.lib; {
    description = ''A small QR-code tool'';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = with platforms; linux;
  };
}
