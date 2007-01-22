{stdenv, fetchurl, nasm, perl}:

stdenv.mkDerivation {
  name = "syslinux-3.31";
  src = fetchurl {
    url = http://www.nl.kernel.org/pub/linux/utils/boot/syslinux/syslinux-3.31.tar.bz2;
    sha256 = "1w0hw28w97mj27h4w64wn9bi24zcff1i8ifcxnbh4iing1pcmi2p";
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
