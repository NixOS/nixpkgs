{ lib, stdenv, fetchFromGitHub, libarchive, iucode-tool }:

stdenv.mkDerivation rec {
  pname = "microcode-intel";
<<<<<<< HEAD
  version = "20230808";
=======
  version = "20230512";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "intel";
    repo = "Intel-Linux-Processor-Microcode-Data-Files";
    rev = "microcode-${version}";
<<<<<<< HEAD
    hash = "sha256-xyb4FUV7vG2YSuN4H6eBaf8c4At70NZiUuepbgg2HNg=";
=======
    hash = "sha256-Ay907cXbT+LlE4foK4TODcDB5Rx/Zo7HY17erem71rw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ iucode-tool libarchive ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out kernel/x86/microcode
    iucode_tool -w kernel/x86/microcode/GenuineIntel.bin intel-ucode/
    touch -d @$SOURCE_DATE_EPOCH kernel/x86/microcode/GenuineIntel.bin
    echo kernel/x86/microcode/GenuineIntel.bin | bsdtar --uid 0 --gid 0 -cnf - -T - | bsdtar --null -cf - --format=newc @- > $out/intel-ucode.img

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.intel.com/";
    description = "Microcode for Intel processors";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
