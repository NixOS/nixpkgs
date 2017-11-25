{ stdenv, fetchFromGitHub, kernel, kmod, perl, patchutils, perlPackages }:
let
  media = fetchFromGitHub {
    owner = "tbsdtv";
    repo = "linux_media";
    rev = "14ebbec91f2cd0423aaf859fc6e6d5d986397cd4";
    sha256 = "1cmqj3kby8sxfcpvslbxywr95529vjxzbn800fdp35lka1fv962h";
  };
  build = fetchFromGitHub {
    owner = "tbsdtv";
    repo = "media_build";
    rev = "c340e29a4047e43f7ea7ebf19e1e28c1f2112d05";
    sha256 = "0hfn1j9qk8lh30z3ywj22qky480nsf8z2iag2bqhrhy4375vjlbl";
  };
in stdenv.mkDerivation {
  name = "tbs-2017-11-05-${kernel.version}";

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

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = [ patchutils kmod perl perlPackages.ProcProcessTable ];

  meta = with stdenv.lib; {
    homepage = https://www.tbsdtv.com/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ck3d ];
    priority = 20;
  };
}
