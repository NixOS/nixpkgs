{ stdenv, fetchurl, libxslt, docbook_xsl, libcap }:

stdenv.mkDerivation rec {
  pname = "bubblewrap";
  version = "0.4.1";

  src = fetchurl {
    url = "https://github.com/containers/bubblewrap/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "00ycgi6q2yngh06bnz50wkvar6r2jnjf3j158grhi9k13jdrpimr";
  };

  nativeBuildInputs = [ libcap libxslt docbook_xsl ];

  meta = with stdenv.lib; {
    description = "Unprivileged sandboxing tool";
    homepage = "https://github.com/containers/bubblewrap";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
