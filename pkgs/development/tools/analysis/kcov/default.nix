{stdenv, fetchFromGitHub, cmake, pkgconfig, zlib, curl, elfutils, python, libiberty, libopcodes}:

stdenv.mkDerivation rec {
  name = "kcov-${version}";
  version = "34";

  src = fetchFromGitHub {
    owner = "SimonKagstrom";
    repo = "kcov";
    rev = "v${version}";
    sha256 = "1i4pn5na8m308pssk8585nmqi8kwd63a9h2rkjrn4w78ibmxvj01";
  };

  preConfigure = "patchShebangs src/bin-to-c-source.py";
  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ zlib curl elfutils python libiberty libopcodes ];

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

    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.linux;
  };
}
