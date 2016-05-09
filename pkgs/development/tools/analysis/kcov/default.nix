{stdenv, fetchurl, cmake, pkgconfig, zlib, curl, elfutils, python, libiberty, binutils}:
stdenv.mkDerivation rec {
  name = "kcov-${version}";
  version = "29";

  src = fetchurl {
    url = "https://github.com/SimonKagstrom/kcov/archive/v${version}.tar.gz";
    sha256 = "0nspf1bfq8zv7zmcmvkbgg3c90k10qcd56gyg8ln5z64nadvha9d";
  };

  preConfigure = "patchShebangs src/bin-to-c-source.py";
  buildInputs = [ cmake pkgconfig zlib curl elfutils python libiberty binutils ];
  
  meta = with stdenv.lib; {
    description = "code coverage tester for compiled programs, Python scripts and shell scripts";

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
    };
    
  }
