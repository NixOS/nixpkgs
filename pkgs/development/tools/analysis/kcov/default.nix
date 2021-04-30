{lib, stdenv, fetchFromGitHub, cmake, pkg-config, zlib, curl, elfutils, python3, libiberty, libopcodes}:

stdenv.mkDerivation rec {
  pname = "kcov";
  version = "38";

  src = fetchFromGitHub {
    owner = "SimonKagstrom";
    repo = "kcov";
    rev = "v${version}";
    sha256 = "sha256-6LoIo2/yMUz8qIpwJVcA3qZjjF+8KEM1MyHuyHsQD38=";
  };

  preConfigure = "patchShebangs src/bin-to-c-source.py";
  nativeBuildInputs = [ cmake pkg-config python3 ];

  buildInputs = [ curl zlib elfutils libiberty libopcodes ];

  strictDeps = true;

  meta = with lib; {
    description = "Code coverage tester for compiled programs, Python scripts and shell scripts";

    longDescription = ''
      Kcov is a code coverage tester for compiled programs, Python
      scripts and shell scripts. It allows collecting code coverage
      information from executables without special command-line
      arguments, and continuosly produces output from long-running
      applications.
    '';

    homepage = "http://simonkagstrom.github.io/kcov/index.html";
    license = licenses.gpl2;

    maintainers = with maintainers; [ gal_bolle ekleog ];
    platforms = platforms.linux;
  };
}
