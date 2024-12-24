{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
  kmod,
  patchutils,
  perlPackages,
}:
let

  media = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "linux_media";
    rev = "cf8cf4c06090fe3c2dc2f665764abc580b8a1921";
    hash = "sha256-YTITVsSktxAoWBsIN6jXZD11pxXaMrMl5N6VZYxfTi0=";
  };

  build = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "media_build";
    rev = "f362ab16cb88cc1d3599408c22e3abc52aebe1fc";
    hash = "sha256-xsZdrOgf+dA5B/GVWSnWUw0FInswPd1Kzg/qWE2JmqM=";
  };

in
stdenv.mkDerivation {
  pname = "tbs";
  version = "20241213-${kernel.version}";

  srcs = [
    media
    build
  ];
  sourceRoot = build.name;

  # https://github.com/tbsdtv/linux_media/wiki
  preConfigure = ''
    make dir DIR=../${media.name}
    make allyesconfig
    sed --regexp-extended --in-place v4l/.config \
      -e 's/(^CONFIG.*_RC.*=)./\1n/g' \
      -e 's/(^CONFIG.*_IR.*=)./\1n/g' \
      -e 's/(^CONFIG_VIDEO_VIA_CAMERA=)./\1n/g'
  '';

  postPatch = ''
    patchShebangs .

    sed -i v4l/Makefile \
      -i v4l/scripts/make_makefile.pl \
      -e 's,/sbin/depmod,${kmod}/bin/depmod,g' \
      -e 's,/sbin/lsmod,${kmod}/bin/lsmod,g'

    sed -i v4l/Makefile \
      -e 's,^OUTDIR ?= /lib/modules,OUTDIR ?= ${kernel.dev}/lib/modules,' \
      -e 's,^SRCDIR ?= /lib/modules,SRCDIR ?= ${kernel.dev}/lib/modules,'
  '';

  buildFlags = [ "VER=${kernel.modDirVersion}" ];
  installFlags = [ "DESTDIR=$(out)" ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [
    patchutils
    kmod
    perlPackages.ProcProcessTable
  ] ++ kernel.moduleBuildDependencies;

  postInstall = ''
    find $out/lib/modules/${kernel.modDirVersion} -name "*.ko" -exec xz {} \;
  '';

  meta = {
    homepage = "https://www.tbsdtv.com/";
    description = "Linux driver for TBSDTV cards";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ck3d ];
    priority = -1;
    broken = kernel.kernelOlder "4.14" || kernel.kernelAtLeast "6.13";
  };
}
