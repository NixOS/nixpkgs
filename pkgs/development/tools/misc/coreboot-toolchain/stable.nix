{ fetchurl }: [
  {
    name = "gmp-6.2.1.tar.xz";
    archive = fetchurl {
      sha256 = "1wml97fdmpcynsbw9yl77rj29qibfp652d0w3222zlfx5j8jjj7x";
      url = "mirror://gnu/gmp/gmp-6.2.1.tar.xz";
    };
  }
  {
    name = "mpfr-4.1.0.tar.xz";
    archive = fetchurl {
      sha256 = "0zwaanakrqjf84lfr5hfsdr7hncwv9wj0mchlr7cmxigfgqs760c";
      url = "mirror://gnu/mpfr/mpfr-4.1.0.tar.xz";
    };
  }
  {
    name = "mpc-1.2.1.tar.gz";
    archive = fetchurl {
      sha256 = "0n846hqfqvmsmim7qdlms0qr86f1hck19p12nq3g3z2x74n3sl0p";
      url = "mirror://gnu/mpc/mpc-1.2.1.tar.gz";
    };
  }
  {
    name = "gcc-11.2.0.tar.xz";
    archive = fetchurl {
      sha256 = "12zs6vd2rapp42x154m479hg3h3lsafn3xhg06hp5hsldd9xr3nh";
      url = "mirror://gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz";
    };
  }
  {
    name = "binutils-2.37.tar.xz";
    archive = fetchurl {
      sha256 = "0b53hhgfnafw27y0c3nbmlfidny2cc5km29pnfffd8r0y0j9f3c2";
      url = "mirror://gnu/binutils/binutils-2.37.tar.xz";
    };
  }
  {
    name = "acpica-unix2-20211217.tar.gz";
    archive = fetchurl {
      sha256 = "0521hmaw2zhi0mpgnaf2i83dykfgql4bx98cg7xqy8wmj649z194";
      url = "https://acpica.org/sites/acpica/files/acpica-unix2-20211217.tar.gz";
    };
  }
  {
    name = "nasm-2.15.05.tar.bz2";
    archive = fetchurl {
      sha256 = "1l1gxs5ncdbgz91lsl4y7w5aapask3w02q9inayb2m5bwlwq6jrw";
      url = "https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2";
    };
  }
]
