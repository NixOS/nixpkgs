{ lib, stdenv, buildPackages, kernel, pciutils, gettext }:

stdenv.mkDerivation {
  pname = "cpupower";
<<<<<<< HEAD
  inherit (kernel) version src patches;
=======
  inherit (kernel) version src;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ gettext ];
  buildInputs = [ pciutils ];

  postPatch = ''
    cd tools/power/cpupower
    sed -i 's,/bin/true,${buildPackages.coreutils}/bin/true,' Makefile
    sed -i 's,/bin/pwd,${buildPackages.coreutils}/bin/pwd,' Makefile
    sed -i 's,/usr/bin/install,${buildPackages.coreutils}/bin/install,' Makefile
  '';

  makeFlags = [
    "CROSS=${stdenv.cc.targetPrefix}"
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}cc"
  ];

  installFlags = lib.mapAttrsToList
    (n: v: "${n}dir=${placeholder "out"}/${v}") {
    bin = "bin";
    sbin = "sbin";
    man = "share/man";
    include = "include";
    lib = "lib";
    locale = "share/locale";
    doc = "share/doc/cpupower";
    conf = "etc";
    bash_completion_ = "share/bash-completion/completions";
  };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tool to examine and tune power saving features";
    homepage = "https://www.kernel.org/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
