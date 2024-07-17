{
  fetchurl,
  lib,
  stdenv,
  expect,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "dejagnu";
  version = "1.6.3";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1qx2cv6qkxbiqg87jh217jb62hk3s7dmcs4cz1llm2wmsynfznl7";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ expect ];

  # dejagnu-1.6.3 can't successfully run tests in source tree:
  #   https://wiki.linuxfromscratch.org/lfs/ticket/4871
  preConfigure = ''
    mkdir build
    cd build
  '';
  configureScript = "../configure";

  doCheck = !(with stdenv; isDarwin && isAarch64);

  # Note: The test-suite *requires* /dev/pts among the `build-chroot-dirs' of
  # the build daemon when building in a chroot.  See
  # <https://www.mail-archive.com/nix-dev@cs.uu.nl/msg01056.html> for
  # details.

  # The test-suite needs to have a non-empty stdin:
  #   https://lists.gnu.org/archive/html/bug-dejagnu/2003-06/msg00002.html
  checkPhase = ''
    # Provide `runtest' with a log name, otherwise it tries to run
    # `whoami', which fails when in a chroot.
    LOGNAME="nix-build-daemon" make check < /dev/zero
  '';

  postInstall = ''
    # 'runtest' and 'dejagnu' look up 'expect' in their 'bin' path
    # first. We avoid use of 'wrapProgram' here because  wrapping
    # of shell scripts does not preserve argv[0] for schell scripts:
    #   https://sourceware.org/PR30052#c5
    ln -s ${expect}/bin/expect $out/bin/expect
  '';

  meta = with lib; {
    description = "Framework for testing other programs";

    longDescription = ''
      DejaGnu is a framework for testing other programs.  Its purpose
      is to provide a single front end for all tests.  Think of it as a
      custom library of Tcl procedures crafted to support writing a
      test harness.  A test harness is the testing infrastructure that
      is created to support a specific program or tool.  Each program
      can have multiple testsuites, all supported by a single test
      harness.  DejaGnu is written in Expect, which in turn uses Tcl --
      Tool command language.
    '';

    homepage = "https://www.gnu.org/software/dejagnu/";
    license = licenses.gpl2Plus;

    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
  };
}
