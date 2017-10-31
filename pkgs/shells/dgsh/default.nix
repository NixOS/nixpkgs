{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig,
  libtool, check, bison, git, gperf,
  perl, texinfo, help2man, gettext, ncurses
}:

stdenv.mkDerivation rec {
  name = "dgsh-unstable-${version}";
  version = "2017-02-05";

  src = fetchFromGitHub {
    owner = "dspinellis";
    repo = "dgsh";
    rev = "bc4fc2e8009c069ee4df5140c32a2fc15d0acdec";
    sha256 = "0k3hmnarz56wphw45mabn5zcc427l5p77jldh1qqy89pxqy1wnql";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ autoconf automake pkgconfig libtool check
    bison git gettext gperf perl texinfo help2man ncurses
  ];

  configurePhase = ''
    cp -r ./unix-tools/coreutils/gnulib gnulib
    perl -pi -e \
      's#./bootstrap #./bootstrap --no-bootstrap-sync --skip-po --no-git --gnulib-srcdir='$PWD/gnulib' #g' \
      unix-tools/Makefile
    find . -name \*.diff | xargs rm -f
    rm -rf unix-tools/*/gnulib
    patchShebangs unix-tools/diffutils/man/help2man
    export RSYNC=true # set to rsync binary, eventhough it is not used.
    make PREFIX=$out config
  '';

  meta = with stdenv.lib; {
    description = "The Directed Graph Shell";
    homepage = http://www.dmst.aueb.gr/dds/sw/dgsh;
    license = with licenses; asl20;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; all;
  };
}
