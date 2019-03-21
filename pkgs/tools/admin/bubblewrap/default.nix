{ stdenv, fetchurl, libxslt, docbook_xsl, libcap }:

stdenv.mkDerivation rec {
  name = "bubblewrap-${version}";
  version = "0.3.1";

  src = fetchurl {
    url = "https://github.com/projectatomic/bubblewrap/releases/download/v${version}/${name}.tar.xz";
    sha256 = "1y2bdlxnlr84xcbf31lzirc292c5ak9bd2wvcvh4ppsliih6pjny";
  };

  nativeBuildInputs = [ libcap libxslt docbook_xsl ];

  meta = with stdenv.lib; {
    description = "Unprivileged sandboxing tool";
    homepage = https://github.com/projectatomic/bubblewrap;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
