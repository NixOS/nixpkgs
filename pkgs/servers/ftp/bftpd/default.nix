{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "bftpd";
  version = "4.4";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/${pname}/${name}/${name}.tar.gz";
    sha256 = "0hgpqwv7mj1yln8ps9bbcjhl5hvs02nxjfkk9nhkr6fysfyyn1dq";
  };
  buildInputs = [];
  preConfigure = ''
    sed -re 's/-[og] 0//g' -i Makefile*
  '';
  meta = {
    inherit version;
    description = ''A minimal ftp server'';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://bftpd.sf.net/;
    downloadPage = "http://bftpd.sf.net/download.html";
  };
}
