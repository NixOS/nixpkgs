{
  lib,
  stdenv,
  buildPackages,
  kernel,
  pciutils,
  gettext,
  which,
}:

stdenv.mkDerivation {
  pname = "cpupower";
  inherit (kernel) version src patches;

  nativeBuildInputs = [
    gettext
    which
  ];
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

  installFlags = lib.mapAttrsToList (n: v: "${n}dir=${placeholder "out"}/${v}") {
    bin = "bin";
    sbin = "sbin";
    man = "share/man";
    include = "include";
    lib = "lib";
    libexec = "libexec";
    locale = "share/locale";
    doc = "share/doc/cpupower";
    conf = "etc";
    bash_completion_ = "share/bash-completion/completions";
    unit = "lib/systemd/system";
  };

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tool to examine and tune power saving features";
    homepage = "https://www.kernel.org/";
    license = licenses.gpl2Only;
    mainProgram = "cpupower";
    platforms = platforms.linux;
  };
}
