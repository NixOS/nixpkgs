{ fetchFromGitHub, kernel, stdenv }:

with stdenv.lib;

let pkgName = "mba6x_bl";
in

stdenv.mkDerivation rec {
  name = "${pkgName}-2016-02-12";

  src = fetchFromGitHub {
    owner = "patjak";
    repo = pkgName;
    rev = "9c2de8a24e7d4e8506170a19d32d6f11f380a142";
    sha256 = "1zaypai8lznqcaszb6an643amsvr5qjnqj6aq6jkr0qk37x0fjff";
  };

  enableParallelBuilding = true;

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = {
    description = "MacBook Air 6,1 and 6,2 (mid 2013) backlight driver";
    homepage = "https://github.com/patjak/mba6x_bl";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.simonvandel ];
  };
}
