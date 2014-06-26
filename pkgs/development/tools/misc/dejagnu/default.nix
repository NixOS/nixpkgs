{ fetchurl, stdenv, expect, makeWrapper }:

stdenv.mkDerivation rec {
  name = "dejagnu-1.5.1";

  src = fetchurl {
    url = "mirror://gnu/dejagnu/${name}.tar.gz";
    sha256 = "1lik8h4qi7x0mhsi8xmj91an1yb63rjbk6v4xrmzgiy5lk8lgrv0";
  };

  patches = [ ./wrapped-runtest-program-name.patch ];

  buildInputs = [ expect makeWrapper ];

  doCheck = true;

  # Note: The test-suite *requires* /dev/pts among the `build-chroot-dirs' of
  # the build daemon when building in a chroot.  See
  # <http://thread.gmane.org/gmane.linux.distributions.nixos/1036> for
  # details.

  # The test-suite needs to have a non-empty stdin:
  #   http://lists.gnu.org/archive/html/bug-dejagnu/2003-06/msg00002.html
  checkPhase = ''
    # Provide `runtest' with a log name, otherwise it tries to run
    # `whoami', which fails when in a chroot.
    LOGNAME="nix-build-daemon" make check < /dev/zero
  '';

  postInstall = ''
    wrapProgram "$out/bin/runtest" \
      --prefix PATH ":" "${expect}/bin"
  '';

  meta = {
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

    homepage = http://www.gnu.org/software/dejagnu/;
    license = "GPLv2+";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
