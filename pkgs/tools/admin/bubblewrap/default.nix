{ stdenv, fetchurl, libxslt, docbook_xsl, libcap }:

stdenv.mkDerivation rec {
  name = "bubblewrap-${version}";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/projectatomic/bubblewrap/releases/download/v${version}/${name}.tar.xz";
    sha256 = "0ahw30ngpclk3ssa81cb7ydc6a4xc5dpqn6kmxfpc9xr30vimdnc";
  };

  nativeBuildInputs = [ libcap libxslt docbook_xsl ];

  meta = with stdenv.lib; {
    description = "Unprivileged sandboxing tool";
    homepage = https://github.com/projectatomic/bubblewrap;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ konimex ];
  };
}
