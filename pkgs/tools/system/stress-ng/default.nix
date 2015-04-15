{ stdenv, fetchurl, attr }:

let version = "0.03.21"; in
stdenv.mkDerivation rec {
  name = "stress-ng-${version}";

  src = fetchurl {
    sha256 = "1gshvxi2v01mw4nlv65gxcd75s7syhx2arhjm68a1m6q7hhiv5w5";
    url = "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/${name}.tar.gz";
  };

  buildInputs = [ attr ];

  patchPhase = ''
    substituteInPlace Makefile --replace "/usr" ""
  '';

  enableParallelBuilding = true;

  installFlags = [ "DESTDIR=$(out)" ];

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
    license = with licenses; gpl2Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
