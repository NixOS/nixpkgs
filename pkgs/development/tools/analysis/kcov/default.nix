{stdenv, fetchFromGitHub, cmake, pkgconfig, zlib, curl, elfutils, python, libiberty, libopcodes}:

stdenv.mkDerivation rec {
  name = "kcov-${version}";
  version = "35";

  src = fetchFromGitHub {
    owner = "SimonKagstrom";
    repo = "kcov";
    rev = "v${version}";
    sha256 = "1da9vm87pi5m9ika0q1f1ai85w3vwlap8yln147yr9sc37jp5jcw";
  };

  preConfigure = "patchShebangs src/bin-to-c-source.py";
  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ zlib curl elfutils python libiberty libopcodes ];

  patches = [ ./aarch64_nt_prstatus.patch ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Code coverage tester for compiled programs, Python scripts and shell scripts";

    longDescription = ''
      Kcov is a code coverage tester for compiled programs, Python
      scripts and shell scripts. It allows collecting code coverage
      information from executables without special command-line
      arguments, and continuosly produces output from long-running
      applications.
    '';

    homepage = http://simonkagstrom.github.io/kcov/index.html;
    license = licenses.gpl2;

    maintainers = with maintainers; [ gal_bolle ekleog ];
    platforms = platforms.linux;
  };
}
