{ stdenv, fetchurl, attr, keyutils }:

stdenv.mkDerivation rec {
  name = "stress-ng-${version}";
  version = "0.06.14";

  src = fetchurl {
    sha256 = "06kycxfwkdrm2vs9xk8cb6c1mki29ymrrqwwxxqx4icnwvq135hv";
    url = "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/${name}.tar.gz";
  };

  buildInputs = [ attr keyutils ];

  patchPhase = ''
    substituteInPlace Makefile --replace "/usr" ""
  '';

  # Won't build on i686 because the binary will be linked again in the
  # install phase without checking the dependencies. This will prevent
  # triggering the rebuild. Why this only happens on i686 remains a
  # mystery, though. :-(
  enableParallelBuilding = (!stdenv.isi686);

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    description = "Stress test a computer system";
    longDescription = ''
      Stress test a system in various selectable ways, exercising both various
      physical subsystems and various operating system kernel interfaces:
      - over 130 different stress tests
      - over 70 CPU specific stress tests that exercise floating point,
        integer, bit manipulation and control flow
      - over 20 virtual memory stress tests
      stress-ng was originally intended to make a machine work hard and trip
      hardware issues such as thermal overruns as well as operating system
      bugs that only occur when a system is being thrashed hard.
    '';
    homepage = http://kernel.ubuntu.com/~cking/stress-ng;
    downloadPage = http://kernel.ubuntu.com/~cking/tarballs/stress-ng/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
