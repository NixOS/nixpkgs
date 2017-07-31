{ stdenv, fetchurl, libxslt, docbook_xsl, libcap }:

stdenv.mkDerivation rec {
  name = "bubblewrap-${version}";
  version = "0.1.8";

  src = fetchurl {
    url = "https://github.com/projectatomic/bubblewrap/releases/download/v${version}/${name}.tar.xz";
    sha256 = "1gyy7paqwdrfgxamxya991588ryj9q9c3rhdh31qldqyh9qpy72c";
  };

  nativeBuildInputs = [ libcap libxslt docbook_xsl ];

  meta = with stdenv.lib; {
    description = "Unprivileged sandboxing tool";
    homepage = https://github.com/projectatomic/bubblewrap;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ konimex ];
  };
}
