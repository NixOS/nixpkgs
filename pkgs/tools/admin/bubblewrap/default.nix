{ stdenv, fetchurl, libxslt, docbook_xsl, libcap }:

stdenv.mkDerivation rec {
  pname = "bubblewrap";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/projectatomic/bubblewrap/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "08r0f4c3fjkb4zjrb4kkax1zfcgcgic702vb62sjjw5xfhppvzp5";
  };

  nativeBuildInputs = [ libcap libxslt docbook_xsl ];

  meta = with stdenv.lib; {
    description = "Unprivileged sandboxing tool";
    homepage = https://github.com/projectatomic/bubblewrap;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
