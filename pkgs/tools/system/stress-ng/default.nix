{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.03.09";
  name = "stress-ng-${version}";

  src = fetchurl {
    url = "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/${name}.tar.gz";
    sha256 = "0lpm04yn7jkfbmdhv73vnnskj492cwvcddh962pgz1mb5rzdkskj";
  };

  patchPhase = ''
    substituteInPlace Makefile --replace "/usr" ""
  '';

  enableParallelBuilding = true;

  makeFlags = "DESTDIR=$(out)";

  meta = with stdenv.lib; {
    description = "Stress test a computer system";
    longDescription = ''
      Stress test a computer system in various selectable ways, by exercising
      various physical subsystems of a computer as well as the various
      operating system kernel interfaces. Stress-ng features:
      - over 60 different stress tests
      - over 50 CPU specific stress tests that exercise floating point,
        integer, bit manipulation and control flow
      - over 20 virtual memory stress tests
      stress-ng was originally intended to make a machine work hard and trip
      hardware issues such as thermal overruns as well as operating system
      bugs that only occur when a system is being thrashed hard.
    '';
    homepage = http://kernel.ubuntu.com/~cking/stress-ng/;
    license = with licenses; gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
