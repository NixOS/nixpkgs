{ stdenv, fetchFromGitHub, gtk3, pkgconfig, intltool, libxslt }:

stdenv.mkDerivation rec {
  version = "0.5.4.14";
  pname = "xarchiver";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = version;
    sha256 = "1iklwgykgymrwcc5p1cdbh91v0ih1m58s3w9ndl5kyd44bwlb7px";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 intltool libxslt ];

  meta = {
    description = "GTK frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = https://github.com/ib/xarchiver;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
