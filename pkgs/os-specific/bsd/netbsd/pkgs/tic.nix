{
  mkDerivation,
  bsdSetupHook,
  netbsdSetupHook,
  makeMinimal,
  install,
  mandoc,
  groff,
  nbperf,
  rsync,
  compatIfNeeded,
  defaultMakeFlags,
  libterminfo,
  fetchNetBSD,
}:

mkDerivation {
  path = "tools/tic";
  version = "9.2";
  sha256 = "092y7db7k4kh2jq8qc55126r5qqvlb8lq8mhmy5ipbi36hwb4zrz";
  HOSTPROG = "tic";
  buildInputs = compatIfNeeded;
  nativeBuildInputs = [
    bsdSetupHook
    netbsdSetupHook
    makeMinimal
    install
    mandoc
    groff
    nbperf
    rsync
  ];
  makeFlags = defaultMakeFlags ++ [ "TOOLDIR=$(out)" ];
  extraPaths = [
    libterminfo.src
    (fetchNetBSD "usr.bin/tic" "9.2" "1mwdfg7yx1g43ss378qsgl5rqhsxskqvsd2mqvrn38qw54i8v5i1")
    (fetchNetBSD "tools/Makefile.host" "9.2" "15b4ab0n36lqj00j5lz2xs83g7l8isk3wx1wcapbrn66qmzz2sxy")
  ];
}
