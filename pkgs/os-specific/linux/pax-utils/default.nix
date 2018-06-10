{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pax-utils-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "https://dev.gentoo.org/~vapier/dist/${name}.tar.xz";
    sha512 = "26f7lqr1s2iywj8qfbf24sm18bl6f7cwsf77nxwwvgij1z88gvh6yx3gp65zap92l0xjdp8kwq9y96xld39p86zd9dmkm447czykbvb";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "ELF utils that can check files for security relevant properties";
    longDescription = ''
      A suite of ELF tools to aid auditing systems. Contains
      various ELF related utils for ELF32, ELF64 binaries useful
      for displaying PaX and security info on a large groups of
      binary files.
    '';
    homepage = https://wiki.gentoo.org/wiki/Hardened/PaX_Utilities;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice joachifm ];
  };
}
