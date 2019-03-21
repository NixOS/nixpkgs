{ stdenv, lib, fetchFromGitHub
, gcc-arm-embedded, binutils-arm-embedded, libftdi
, python, pythonPackages
}:

with lib;

stdenv.mkDerivation rec {
  name = "blackmagic-${version}";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "blacksphere";
    repo = "blackmagic";
    rev = "29386aee140e5e99a958727358f60980418b4c88";
    sha256 = "05x19y80mixk6blpnfpfngy5d41jpjvdqgjzkmhv1qc03bhyhc82";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    gcc-arm-embedded binutils-arm-embedded
  ];

  buildInputs = [
    libftdi
    python
    pythonPackages.intelhex
  ];

  postPatch = ''
    # Prevent calling out to `git' to generate a version number:
    substituteInPlace src/Makefile \
      --replace '`git describe --always --dirty`' '${version}'

    # Fix scripts that generate headers:
    for f in $(find scripts libopencm3/scripts -type f); do
      patchShebangs "$f"
    done
  '';

  buildPhase = "${stdenv.shell} ${./helper.sh}";
  installPhase = ":"; # buildPhase does this.

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
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.unix;
  };
}
