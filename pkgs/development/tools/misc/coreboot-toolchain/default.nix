{ lib, stdenvNoCC, fetchurl, fetchgit,
  gnumake, patch, zlib, git, bison,
  flex, gnat11, curl, perl
}:

let
  version_coreboot      = "4.14";

  version_gmp           = "6.2.0";
  version_mpfr          = "4.1.0";
  version_mpc           = "1.2.0";
  version_gcc           = "8.3.0";
  version_binutils      = "2.35.1";
  version_acpica        = "20200925";
  version_nasm          = "2.15.05";

  tar_name_gmp = "gmp-${version_gmp}.tar.xz";
  tar_gmp = fetchurl {
    url = "https://ftpmirror.gnu.org/gmp/${tar_name_gmp}";
    sha256 = "09hmg8k63mbfrx1x3yy6y1yzbbq85kw5avbibhcgrg9z3ganr3i5";
  };

  tar_name_mpfr = "mpfr-${version_mpfr}.tar.xz";
  tar_mpfr = fetchurl {
    url = "https://ftpmirror.gnu.org/mpfr/${tar_name_mpfr}";
    sha256 = "0zwaanakrqjf84lfr5hfsdr7hncwv9wj0mchlr7cmxigfgqs760c";
  };

  tar_name_mpc = "mpc-${version_mpc}.tar.gz";
  tar_mpc = fetchurl {
    url = "https://ftpmirror.gnu.org/mpc/${tar_name_mpc}";
    sha256 = "19pxx3gwhwl588v496g3aylhcw91z1dk1d5x3a8ik71sancjs3z9";
  };

  tar_name_gcc = "gcc-${version_gcc}.tar.xz";
  tar_gcc = fetchurl {
    url = "https://ftpmirror.gnu.org/gcc/gcc-${version_gcc}/${tar_name_gcc}";
    sha256 = "0b3xv411xhlnjmin2979nxcbnidgvzqdf4nbhix99x60dkzavfk4";
  };

  tar_name_binutils = "binutils-${version_binutils}.tar.xz";
  tar_binutils = fetchurl {
    url = "https://ftpmirror.gnu.org/binutils/${tar_name_binutils}";
    sha256 = "01w6xvfy7sjpw8j08k111bnkl27j760bdsi0wjvq44ghkgdr3v9w";
  };

  tar_name_acpica = "acpica-unix2-${version_acpica}.tar.gz";
  tar_acpica = fetchurl {
    url = "https://acpica.org/sites/acpica/files/${tar_name_acpica}";
    sha256 = "18n6129fkgj85piid7v4zxxksv3h0amqp4p977vcl9xg3bq0zd2w";
  };

  tar_name_nasm = "nasm-${version_nasm}.tar.bz2";
  tar_nasm = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${version_nasm}/${tar_name_nasm}";
    sha256 = "1l1gxs5ncdbgz91lsl4y7w5aapask3w02q9inayb2m5bwlwq6jrw";
  };

  tar_coreboot_name = "coreboot-${version_coreboot}.tar.xz";
  tar_coreboot = fetchurl {
    url = "https://coreboot.org/releases/${tar_coreboot_name}";
    sha256 = "0viw2x4ckjwiylb92w85k06b0g9pmamjy2yqs7fxfqbmfadkf1yr";
  };
in stdenvNoCC.mkDerivation rec {
  name = "coreboot-toolchain";
  version = version_coreboot;
  src = tar_coreboot;

  nativeBuildInputs = [ perl curl gnumake git bison ];

  buildInputs = [ gnat11 flex zlib ];

  enableParallelBuilding = true;
  dontConfigure = true;
  dontInstall = true;

  patchPhase = ''
    mkdir util/crossgcc/tarballs
    ln -s ${tar_gmp}            util/crossgcc/tarballs/${tar_name_gmp}
    ln -s ${tar_mpfr}           util/crossgcc/tarballs/${tar_name_mpfr}
    ln -s ${tar_mpc}            util/crossgcc/tarballs/${tar_name_mpc}
    ln -s ${tar_gcc}            util/crossgcc/tarballs/${tar_name_gcc}
    ln -s ${tar_binutils}       util/crossgcc/tarballs/${tar_name_binutils}
    ln -s ${tar_acpica}         util/crossgcc/tarballs/${tar_name_acpica}
    ln -s ${tar_nasm}           util/crossgcc/tarballs/${tar_name_nasm}
    patchShebangs util/genbuild_h/genbuild_h.sh util/crossgcc/buildgcc
  '';

  buildPhase = ''
    make crossgcc-i386 CPUS=$NIX_BUILD_CORES DEST=$out
  '';

  meta = with lib; {
    homepage = "https://www.coreboot.org";
    description = "coreboot toolchain";
    license = with licenses; [ bsd2 bsd3 gpl2 lgpl2Plus gpl3Plus ];
    maintainers = with maintainers; [ felixsinger ];
    platforms = platforms.linux;
  };
}
