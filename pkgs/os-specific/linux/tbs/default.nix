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
    rev = "3f1faba3930568fd2d472a2fe8c57af8d7084672";
    hash = "sha256-tq92yqJVJgAYy7PTY/nk0Q6sWJ0kdSrw38JEOOhfwGQ=";
  };

  build = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "media_build";
    rev = "bc02baf59046b02e3eb71653d8aa8d98e79dc4e1";
    hash = "sha256-P0ASmWro3j3dk7LZQbUKXcGL+2c9fdjM7RgEfk0iDMs=";
  };

in
stdenv.mkDerivation {
  pname = "tbs";
  version = "20250510-${kernel.version}";

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
