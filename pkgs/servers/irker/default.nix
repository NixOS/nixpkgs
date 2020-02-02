{ stdenv, fetchFromGitLab, python, pkgconfig
, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_412 }:

stdenv.mkDerivation {
  pname = "irker";
  version = "2017-02-12";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "irker";
    rev = "dc0f65a7846a3922338e72d8c6140053fe914b54";
    sha256 = "1hslwqa0gqsnl3l6hd5hxpn0wlachxd51infifhlwhyhd6iwgx8p";
  };

  nativeBuildInputs = [ pkgconfig xmlto docbook2x docbook_xsl docbook_xml_dtd_412 ];

  buildInputs = [
    python
    # Needed for proxy support I believe, which I haven't tested.
    # Probably needs to be propagated and some wrapPython magic
    # python.pkgs.pysocks
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-o 0 -g 0' ""
  '';

  installFlags = [
    "prefix=/"
    "DESTDIR=$$out"
  ];

  meta = with stdenv.lib; {
    description = "IRC client that runs as a daemon accepting notification requests";
    homepage = https://gitlab.com/esr/irker;
    license = licenses.bsd2;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.unix;
  };
}
