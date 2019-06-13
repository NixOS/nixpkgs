{ stdenv, fetchurl, libxslt, docbook_xsl, libcap }:

stdenv.mkDerivation rec {
  name = "bubblewrap-${version}";
  version = "0.3.3";

  src = fetchurl {
    url = "https://github.com/projectatomic/bubblewrap/releases/download/v${version}/${name}.tar.xz";
    sha256 = "1zsd6rxryg97dkkhibr0fvq16x3s75qj84rvhdv8p42ag58mz966";
  };

  nativeBuildInputs = [ libcap libxslt docbook_xsl ];

  meta = with stdenv.lib; {
    description = "Unprivileged sandboxing tool";
    homepage = https://github.com/projectatomic/bubblewrap;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ ];
  };
}
