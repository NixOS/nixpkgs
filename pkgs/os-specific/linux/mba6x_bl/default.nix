{ fetchFromGitHub, kernel, stdenv }:

with stdenv.lib;

let pkgName = "mba6x_bl";
in

stdenv.mkDerivation rec {
  name = "${pkgName}-${version}";
  version = "2016-04-22";

  src = fetchFromGitHub {
    owner = "patjak";
    repo = pkgName;
    rev = "d05c125efe182376ddab30d486994ec00e144650";
    sha256 = "15h90z3ijq4lv37nmx70xqggcvn21vr7mki2psk1jyj88in3j3xn";
  };

  enableParallelBuilding = true;

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = {
    description = "MacBook Air 6,1 and 6,2 (mid 2013) backlight driver";
    homepage = https://github.com/patjak/mba6x_bl;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.simonvandel ];
  };
}
