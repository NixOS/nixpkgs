{stdenv, fetchurl, nasm, perl}:

stdenv.mkDerivation {
  name = "syslinux-3.35";
  src = fetchurl {
    url = mirror://kernel/linux/utils/boot/syslinux/Old/syslinux-3.35.tar.bz2;
    sha256 = "16kf2zhd0c4m3ai9xcls2y0ggvajhmzk1g6mv6jrv8nskkg6w0l6";
  };
  buildInputs = [nasm perl];

  preBuild = "
    makeFlagsArray=(BINDIR=$out/bin SBINDIR=$out/sbin LIBDIR=$out/lib INCDIR=$out/include)

    # Really dirty hack to get syslinux to build without needing a GCC
    # with 32-bit libraries and headers.
    if test \"$system\" = x86_64-linux; then
        substituteInPlace memdisk/Makefile \\
            --replace 'all: memdisk e820test' 'all: memdisk'
        mkdir gnu
        touch gnu/stubs-32.h
    fi
  ";
}
