{ lib, stdenv, fetchurl, bash, flex, bison, valgrind }:

stdenv.mkDerivation rec {
  pname = "lockdep";

  # it would be nice to be able to pick a kernel version in sync with something
  # else we already ship, but it seems userspace lockdep isn't very well maintained
  # and appears broken in many kernel releases
  version = "5.0.21";
  fullver = "5.0.21";
  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "1my2m9hvnvdrvzcg0fgqgaga59y2cd5zlpv7xrfj2nn98sjhglwq";
  };

  # ensure *this* kernel's userspace-headers are picked up before we
  # fall back to those in glibc, as they will be from a mismatched
  # kernel version
  postPatch = ''
    substituteInPlace tools/lib/lockdep/Makefile \
      --replace 'CONFIG_INCLUDES =' $'CONFIG_INCLUDES = -I../../../usr/include\n#'
  '';

  nativeBuildInputs = [ flex bison ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: lockdep.o:/build/linux-5.0.21/tools/lib/lockdep/../../include/linux/rcu.h:5: multiple definition of
  #     `rcu_scheduler_active'; common.o:/build/linux-5.0.21/tools/lib/lockdep/../../include/linux/rcu.h:5: first defined here
  NIX_CFLAGS_COMPILE = "-fcommon";

  buildPhase = ''
    make defconfig
    make headers_install
    cd tools/lib/lockdep
    make
  '';

  doCheck = true;
  nativeCheckInputs = [ valgrind ];
  checkPhase = ''
    # there are more /bin/bash references than just shebangs
    for f in lockdep run_tests.sh tests/*.sh; do
      substituteInPlace $f \
        --replace '/bin/bash' '${bash}/bin/bash'
    done

    ./run_tests.sh
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/include

    cp -R include/liblockdep $out/include
    make install DESTDIR=$out prefix=""

    substituteInPlace $out/bin/lockdep --replace "./liblockdep.so" "$out/lib/liblockdep.so.$fullver"
  '';

  meta = {
    description = "Userspace locking validation tool built on the Linux kernel";
    homepage    = "https://kernel.org/";
    license     = lib.licenses.gpl2;
    platforms   = lib.platforms.linux;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
