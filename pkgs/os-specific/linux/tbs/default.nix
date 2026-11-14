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
    rev = "2ce787de9f6e81b4294692a45de15596ae2e1322";
    hash = "sha256-mY+InJqBIdZYkPnHPiNQiGkpmxvfdJITsUpRe3+jfUQ=";
  };

  build = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "media_build";
    rev = "ff326ab69e786d447a0e0e967cb45acb5d5ca9ff";
    hash = "sha256-wRmTVyBSHzVGUWYB//B7Q/ewtZJvP7+GlA6tPcACYjw=";
  };

in
stdenv.mkDerivation {
  pname = "tbs";
  version = "20260724-${kernel.version}";

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
  ]
  ++ kernel.moduleBuildDependencies;

  postInstall = ''
    find $out/lib/modules/${kernel.modDirVersion} -name "*.ko" -exec xz {} \;
  '';

  meta = {
    homepage = "https://www.tbsdtv.com/";
    description = "Linux driver for TBSDTV cards";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ck3d ];
    priority = -1;
    broken = kernel.kernelOlder "4.19" || kernel.kernelAtLeast "6.15";
  };
}
