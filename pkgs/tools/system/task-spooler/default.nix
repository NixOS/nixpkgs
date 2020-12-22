{ stdenv, lib, fetchurl, fetchpatch
# The Debian patches rename the task-spooler binary from 'ts' to 'tsp', to not
# conflict with the 'ts' binary from the moreutils package.
, applyDebianPatches ? true
}:

stdenv.mkDerivation rec {
  pname = "task-spooler";
  version = "1.0.1";

  src = fetchurl {
    url = "https://vicerveza.homeunix.net/~viric/soft/ts/ts-${version}.tar.gz";
    sha256 = "0y32sm2i2jxs88c307h76449fynk75p9qfw1k11l5ixrn03z67pl";
  };

  patches = lib.optionals applyDebianPatches [
    # rename executable and man page to tsp
    (fetchpatch {
       url = "https://sources.debian.org/data/main/t/task-spooler/1.0.1+dfsg1-1/debian/patches/tsp.patch";
       sha256 = "1jfrgb62j5dz48jsfqkrzmfw1s52zwnmimm4mqmjpx3n4d32japl";
     })

    # minor fixes to man page
    (fetchpatch {
       url = "https://sources.debian.org/data/main/t/task-spooler/1.0.1+dfsg1-1/debian/patches/manpage.patch";
       sha256 = "0f28r77l39y8vdmaci3z3pfmawpdr7pg803d29r6swlwvymz5k8b";
     })
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Unix batch system where the tasks spooled run one after the other";
    homepage = "http://viric.name/soft/ts/";
    longDescription = ''
      Task spooler is a Unix batch system where the tasks spooled run one after
      the other. Each user in each system has his own job queue. The tasks are
      run in the correct context (that of enqueue) from any shell/process, and
      its output/results can be easily watched. It is very useful when you know
      that your commands depend on a lot of RAM, a lot of disk use, give a lot
      of output, or for whatever reason it's better not to run them at the same
      time.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornf ];
  };
}
