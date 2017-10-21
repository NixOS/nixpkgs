{stdenv, fetchurl, cmake, pkgconfig, zlib, curl, elfutils, python, libiberty, binutils}:

stdenv.mkDerivation rec {
  name = "kcov-${version}";
  version = "32";

  src = fetchurl {
    url = "https://github.com/SimonKagstrom/kcov/archive/v${version}.tar.gz";
    sha256 = "0ic5w6r3cpwb32iky1jmyvfclgkqr0rnfyim7j2r6im21846sa85";
  };

  preConfigure = "patchShebangs src/bin-to-c-source.py";
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake zlib curl elfutils python libiberty binutils ];

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
