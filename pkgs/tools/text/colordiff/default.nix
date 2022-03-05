{ lib, stdenv, fetchFromGitHub, docbook_xml_dtd_412, docbook_xsl, perl, w3m, xmlto }:

stdenv.mkDerivation rec {
  pname = "colordiff";
  version = "1.0.20";

  src = fetchFromGitHub {
    owner = "daveewart";
    repo = "colordiff";
    rev = "v${version}";
    sha256 = "sha256-+TtVnUX88LMd8zmhLsKTyR9JlgR7IkUB18PF3LRgPB0=";
  };

  nativeBuildInputs = [ docbook_xml_dtd_412 docbook_xsl perl w3m xmlto ];

  buildInputs = [ perl ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace 'TMPDIR=colordiff-''${VERSION}' ""
  '';

  installFlags = [
    "INSTALL_DIR=/bin"
    "MAN_DIR=/share/man/man1"
    "DESTDIR=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Wrapper for 'diff' that produces the same output but with pretty 'syntax' highlighting";
    homepage = "https://www.colordiff.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
