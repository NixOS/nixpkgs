{ fetchurl }: [
  {
    name = "gmp-6.2.0.tar.xz";
    archive = fetchurl {
      sha256 = "09hmg8k63mbfrx1x3yy6y1yzbbq85kw5avbibhcgrg9z3ganr3i5";
      url = "mirror://gnu/gmp/gmp-6.2.0.tar.xz";
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
    name = "mpc-1.2.0.tar.gz";
    archive = fetchurl {
      sha256 = "19pxx3gwhwl588v496g3aylhcw91z1dk1d5x3a8ik71sancjs3z9";
      url = "mirror://gnu/mpc/mpc-1.2.0.tar.gz";
    };
  }
  {
    name = "gcc-8.3.0.tar.xz";
    archive = fetchurl {
      sha256 = "0b3xv411xhlnjmin2979nxcbnidgvzqdf4nbhix99x60dkzavfk4";
      url = "mirror://gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.xz";
    };
  }
  {
    name = "binutils-2.35.1.tar.xz";
    archive = fetchurl {
      sha256 = "01w6xvfy7sjpw8j08k111bnkl27j760bdsi0wjvq44ghkgdr3v9w";
      url = "mirror://gnu/binutils/binutils-2.35.1.tar.xz";
    };
  }
  {
    name = "acpica-unix2-20200925.tar.gz";
    archive = fetchurl {
      sha256 = "18n6129fkgj85piid7v4zxxksv3h0amqp4p977vcl9xg3bq0zd2w";
      url = "https://acpica.org/sites/acpica/files/acpica-unix2-20200925.tar.gz";
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
