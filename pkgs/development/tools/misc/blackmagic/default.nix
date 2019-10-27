{ stdenv, lib, fetchFromGitHub
, gcc-arm-embedded, libftdi1
, python, pythonPackages
}:

with lib;

stdenv.mkDerivation rec {
  pname = "blackmagic";
  version = "unstable-2019-08-13";
  # `git describe --always`
  firmwareVersion = "v1.6.1-317-gc9c8b08";

  src = fetchFromGitHub {
    owner = "blacksphere";
    repo = "blackmagic";
    rev = "c9c8b089f716c31433432f5ee54c5c206e4945cf";
    sha256 = "0175plba7h3r1p584ygkjlvg2clvxa2m0xfdcb2v8jza2vzc8ywd";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc-arm-embedded
  ];

  buildInputs = [
    libftdi1
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
    maintainers = with maintainers; [ pjones emily ];
    platforms = platforms.unix;
  };
}
