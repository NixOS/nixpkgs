{ stdenv, fetchurl, attr, keyutils }:

let version = "0.04.15"; in
stdenv.mkDerivation rec {
  name = "stress-ng-${version}";

  src = fetchurl {
    sha256 = "1jazcfviqx3pyhv2jzsp6y37ndsj1smfk6jacpxg9vrg5k3cm3wq";
    url = "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/${name}.tar.gz";
  };

  buildInputs = [ attr keyutils ];

  patchPhase = ''
    substituteInPlace Makefile --replace "/usr" ""
  '';

  enableParallelBuilding = true;

  installFlags = "DESTDIR=$(out)";

  meta = with stdenv.lib; {
    inherit version;
    description = "Stress test a computer system";
    longDescription = ''
      Stress test a system in various selectable ways, exercising both various
      physical subsystems and various operating system kernel interfaces:
      - over 60 different stress tests
      - over 50 CPU specific stress tests that exercise floating point,
        integer, bit manipulation and control flow
      - over 20 virtual memory stress tests
      stress-ng was originally intended to make a machine work hard and trip
      hardware issues such as thermal overruns as well as operating system
      bugs that only occur when a system is being thrashed hard.
    '';
    homepage = http://kernel.ubuntu.com/~cking/stress-ng;
    downloadPage = http://kernel.ubuntu.com/~cking/tarballs/stress-ng/;
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
