{ stdenv, fetchFromGitHub, gtk3, pkgconfig, intltool, libxslt }:

stdenv.mkDerivation rec {
  version = "0.5.4.15";
  pname = "xarchiver";

  src = fetchFromGitHub {
    owner = "ib";
    repo = "xarchiver";
    rev = version;
    sha256 = "0a3y54r5zp2c0cqm77r07qrl1vh200wvqmbhm35diy22fvkq5mwc";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 intltool libxslt ];

  meta = {
    description = "GTK frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = "https://github.com/ib/xarchiver";
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
