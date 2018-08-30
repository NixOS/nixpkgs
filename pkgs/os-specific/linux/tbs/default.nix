{ stdenv, lib, fetchFromGitHub, kernel, kmod, perl, patchutils, perlPackages }:
let

  media = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "linux_media";
    rev = "efe31531b77efd3a4c94516504a5823d31cdc776";
    sha256 = "1533qi3sb91v00289hl5zaj4l35r2sf9fqc6z5ky1vbb7byxgnlr";
  };

  build = fetchFromGitHub rec {
    name = repo;
    owner = "tbsdtv";
    repo = "media_build";
    rev = "a0d62eba4d429e0e9d2c2f910fb203e817cac84b";
    sha256 = "1329s7w9xlqjqwkpaqsd6b5dmzhm97jw0c7c7zzmmbdkl289i4i4";
  };

in stdenv.mkDerivation {
  name = "tbs-2018.04.18-${kernel.version}";

  srcs = [ media build ];
  sourceRoot = "${build.name}";

  preConfigure = ''
    make dir DIR=../${media.name}
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

  hardeningDisable = [ "all" ];

  nativeBuildInputs = [ patchutils kmod perl perlPackages.ProcProcessTable ]
  ++ kernel.moduleBuildDependencies;

   postInstall = ''
    xz $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/media/dvb-core/dvb-core.ko
    xz $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/media/v4l2-core/videodev.ko
  '';

  meta = with lib; {
    homepage = https://www.tbsdtv.com/;
    description = "Linux driver for TBSDTV cards";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ck3d ];
    priority = -1;
    broken = stdenv.lib.versionAtLeast kernel.version "4.18";
  };
}
