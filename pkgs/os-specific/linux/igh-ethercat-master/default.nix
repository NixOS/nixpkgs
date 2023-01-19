{ lib, stdenv, fetchFromGitLab, autoconf, automake, pkg-config, libtool, kmod, iproute2, kernel }:

stdenv.mkDerivation {
  pname = "igh-ethercat-master";
  version = "unstable-2022-11-02-${kernel.modDirVersion}";

  src = fetchFromGitLab {
    owner = "etherlab.org";
    repo = "ethercat";
    rev = "2e2cef6131895336f87c57c18fe78ae01a90d3de";
    sha256 = "sha256-f60MWcbmOGe1Zflig9gxd52HVD8hyJ9AdopCUbsfecg=";
  };

  nativeBuildInputs = [ autoconf automake pkg-config libtool ] ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "all"
    "modules"
  ];

  patches = [
    ./ethercatctl.in.patch
  ];

  postPatch = ''
    # Patch paths in ethercatctl script template
    sed -i script/ethercatctl.in \
      -e 's#LSMOD=/sbin/lsmod#LSMOD=${kmod}/bin/lsmod#' \
      -e 's#MODPROBE=/sbin/modprobe#LSMOD=${kmod}/bin/modprobe#' \
      -e 's#RMMOD=/sbin/rmmod#LSMOD=${kmod}/bin/rmmod#' \
      -e 's#MODINFO=/sbin/modinfo#LSMOD=${kmod}/bin/modinfo#' \
      -e 's#IP=/bin/ip#LSMOD=${iproute2}/bin/ip#'
  '';

  preConfigure = ''
    bash ./bootstrap
  '';

  configureFlags = [
    "--with-linux-dir=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build/"
    "--disable-8139too"
    "--disable-e100"
    "--disable-e1000"
    "--disable-e1000e"
    "--disable-r8169"
    "--disable-igb"
    "--enable-ccat"
  ];

  postConfigure = ''
    # Copy configured build directory, to use with erhetcat-rs (https://github.com/ethercat-rs/ethercat)
    mkdir -p $out/build/
    cp -r * $out/build/
  '';

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d/
    echo KERNEL=\"EtherCAT[0-9]*\", MODE=\"0664\" > $out/etc/udev/rules.d/99-EtherCAT.rules

    mv $out/etc/ $out/templates/

    mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc/
    cp devices/ec_generic.ko $out/lib/modules/${kernel.modDirVersion}/misc/
    cp master/ec_master.ko $out/lib/modules/${kernel.modDirVersion}/misc/
  '';

  meta = with lib; {
    description = "IgH EtherCAT Master for Linux";
    homepage = "https://gitlab.com/etherlab.org/ethercat";
    license = licenses.lgpl21Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.simonkampe ];
  };
}
