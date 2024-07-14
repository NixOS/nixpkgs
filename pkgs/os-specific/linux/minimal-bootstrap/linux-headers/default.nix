{ lib
, fetchurl
, bash
, gnutar
, xz
}:
let
  # WARNING: You probably don't want to use this package outside minimal-bootstrap
  #
  # We need some set of Linux kernel headers to build our bootstrap packages
  # (gcc/binutils/glibc etc.) against. As long as it compiles it is "good enough".
  # Therefore the requirement for correctness, completeness, platform-specific
  # features, and being up-to-date, are very loose.
  #
  # Rebuilding the Linux headers from source correctly is something we can defer
  # till we have access to gcc/binutils/perl. For now we can use Guix's assembled
  # kernel header distribution and assume it's good enough.
  pname = "linux-headers";
  version = "4.14.67";

  src = fetchurl {
    url = "mirror://gnu/gnu/guix/bootstrap/i686-linux/20190815/linux-libre-headers-stripped-4.14.67-i686-linux.tar.xz";
    sha256 = "0sm2z9x4wk45bh6qfs94p0w1d6hsy6dqx9sw38qsqbvxwa1qzk8s";
  };
in
bash.runCommand "${pname}-${version}" {
  inherit pname version;

  nativeBuildInputs = [
    gnutar
    xz
  ];

  meta = with lib; {
    description = "Header files and scripts for Linux kernel";
    license = licenses.gpl2Only;
    maintainers = teams.minimal-bootstrap.members;
    platforms = platforms.linux;
  };
} ''
  # Unpack
  cp ${src} linux-headers.tar.xz
  unxz linux-headers.tar.xz
  tar xf linux-headers.tar

  # Install
  mkdir $out
  cp -r include $out
''
