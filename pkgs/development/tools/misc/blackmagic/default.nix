{ stdenv, lib, fetchFromGitHub
, gcc-arm-embedded, libftdi1, libusb, pkgconfig
, python, pythonPackages
}:

with lib;

stdenv.mkDerivation rec {
  pname = "blackmagic";
  version = "unstable-2020-02-20";
  # `git describe --always`
  firmwareVersion = "v1.6.1-409-g7a595ea";

  src = fetchFromGitHub {
    owner = "blacksphere";
    repo = "blackmagic";
    rev = "7a595ead255f2a052fe4561c24a0577112c9de84";
    sha256 = "01kdm1rkj7ll0px882crf9w27d2ka8f3hcdmvhb9jwd60bf5dlap";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc-arm-embedded pkgconfig
  ];

  buildInputs = [
    libftdi1
    libusb
    python
    pythonPackages.intelhex
  ];

  postPatch = ''
    # Prevent calling out to `git' to generate a version number:
    substituteInPlace src/Makefile \
      --replace '$(shell git describe --always --dirty)' '${firmwareVersion}'

    # Fix scripts that generate headers:
    for f in $(find scripts libopencm3/scripts -type f); do
      patchShebangs "$f"
    done
  '';

  buildPhase = "${stdenv.shell} ${./helper.sh}";
  installPhase = ":"; # buildPhase does this.

  enableParallelBuilding = true;

  meta = {
    description = "In-application debugger for ARM Cortex microcontrollers";
    longDescription = ''
      The Black Magic Probe is a modern, in-application debugging tool
      for embedded microprocessors. It allows you to see what is going
      on "inside" an application running on an embedded microprocessor
      while it executes.

      This package builds the firmware for all supported platforms,
      placing them in separate directories under the firmware
      directory.  It also places the FTDI version of the blackmagic
      executable in the bin directory.
    '';
    homepage = https://github.com/blacksphere/blackmagic;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ pjones emily sorki ];
    # fails on darwin with
    # arm-none-eabi-gcc: error: unrecognized command line option '-iframework'
    platforms = platforms.linux;
  };
}
