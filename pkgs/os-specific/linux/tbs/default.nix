{ stdenv, lib, fetchFromGitHub, kernel, kmod, patchutils, perlPackages }:
let

  media = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "linux_media";
    rev = "d8d1ff33c0c47e34fe3e860b52b4d6c457520866";
    hash = "sha256-1Z9itZ5GFpfUeRtp5xTnS+I91LUZLDhsEcF2v8ThaCs=";
  };

  build = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "media_build";
    rev = "8cd12a6e90999f3a341018812a5d66d7e6b30913";
    hash = "sha256-+I0NrML54ni37qgDHbRUQiLmmw/UZgXmoFoiDNDeH5A=";
  };

in
stdenv.mkDerivation {
  pname = "tbs";
  version = "20240506-${kernel.version}";

  srcs = [ media build ];
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

  nativeBuildInputs = [ patchutils kmod perlPackages.ProcProcessTable ]
    ++ kernel.moduleBuildDependencies;

  postInstall = ''
    find $out/lib/modules/${kernel.modDirVersion} -name "*.ko" -exec xz {} \;
  '';

  meta = with lib; {
    homepage = "https://www.tbsdtv.com/";
    description = "Linux driver for TBSDTV cards";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ck3d ];
    priority = -1;
    broken = kernel.kernelOlder "4.14" || kernel.kernelAtLeast "6.9";
  };
}
