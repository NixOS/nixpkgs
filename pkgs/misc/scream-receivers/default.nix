{ stdenv, lib, fetchFromGitHub, alsaLib
, pulseSupport ? false, libpulseaudio ? null
}:

stdenv.mkDerivation rec {
  pname = "scream-receivers";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "duncanthrax";
    repo = "scream";
    rev = version;
    sha256 = "1ig89bmzfrm57nd8lamzsdz5z81ks5vjvq3f0xhgm2dk2mrgjsj3";
  };

  buildInputs = [ alsaLib ] ++ lib.optional pulseSupport libpulseaudio;

  buildPhase = ''
    (cd Receivers/alsa && make)
    (cd Receivers/alsa-ivshmem && make)
  '' + lib.optionalString pulseSupport ''
    (cd Receivers/pulseaudio && make)
    (cd Receivers/pulseaudio-ivshmem && make)
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv ./Receivers/alsa/scream-alsa $out/bin/
    mv ./Receivers/alsa-ivshmem/scream-ivshmem-alsa $out/bin/
  '' + lib.optionalString pulseSupport ''
    mv ./Receivers/pulseaudio/scream-pulse $out/bin/
    mv ./Receivers/pulseaudio-ivshmem/scream-ivshmem-pulse $out/bin/
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export PATH=$PATH:$out/bin
    set -o verbose
    set +o pipefail

    # Programs exit with code 1 when testing help, so grep for a string
    scream-alsa -h 2>&1 | grep -q Usage:
    scream-ivshmem-alsa 2>&1 | grep -q Usage:
  '' + lib.optionalString pulseSupport ''
    scream-pulse -h 2>&1 | grep -q Usage:
    scream-ivshmem-pulse 2>&1 | grep -q Usage:
  '';

  meta = with lib; {
    description = "Audio receivers for the Scream virtual network sound card";
    homepage = "https://github.com/duncanthrax/scream";
    license = licenses.mspl;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
