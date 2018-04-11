{ stdenv, fetchurl, libxslt, docbook_xsl, libcap }:

stdenv.mkDerivation rec {
  name = "bubblewrap-${version}";
  version = "0.2.1";

  src = fetchurl {
    url = "https://github.com/projectatomic/bubblewrap/releases/download/v${version}/${name}.tar.xz";
    sha256 = "1qhzwgpfsw66hcv5kqc7i4dbzhxr8drrqn3md4grcp7dn02wif2l";
  };

  nativeBuildInputs = [ libcap libxslt docbook_xsl ];

  meta = with stdenv.lib; {
    description = "Unprivileged sandboxing tool";
    homepage = https://github.com/projectatomic/bubblewrap;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ konimex ];
  };
}
