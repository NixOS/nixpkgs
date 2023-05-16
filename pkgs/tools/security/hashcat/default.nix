{ lib, stdenv
<<<<<<< HEAD
, addOpenGLRunpath
, config
, cudaPackages ? {}
, cudaSupport ? config.cudaSupport
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchurl
, makeWrapper
, opencl-headers
, ocl-icd
, xxHash
<<<<<<< HEAD
, Foundation, IOKit, Metal, OpenCL, libiconv
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname   = "hashcat";
  version = "6.2.6";

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${version}.tar.gz";
    sha256 = "sha256-sl4Qd7zzSQjMjxjBppouyYsEeyy88PURRNzzuh4Leyo=";
  };

<<<<<<< HEAD
  postPatch = ''
     # Remove hardcoded paths on darwin
    substituteInPlace src/Makefile \
      --replace "/usr/bin/ar" "ar" \
      --replace "/usr/bin/sed" "sed" \
      --replace '-i ""' '-i'
  '';

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals cudaSupport [
    addOpenGLRunpath
  ];

  buildInputs = [ opencl-headers xxHash ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation IOKit Metal OpenCL libiconv ];
=======
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ opencl-headers xxHash ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "COMPTIME=1337"
    "VERSION_TAG=${version}"
    "USE_SYSTEM_OPENCL=1"
    "USE_SYSTEM_XXHASH=1"
<<<<<<< HEAD
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform) [
    "IS_APPLE_SILICON='${if stdenv.hostPlatform.isAarch64 then "1" else "0"}'"
  ];

  enableParallelBuilding = true;

=======
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preFixup = ''
    for f in $out/share/hashcat/OpenCL/*.cl; do
      # Rewrite files to be included for compilation at runtime for opencl offload
      sed "s|#include \"\(.*\)\"|#include \"$out/share/hashcat/OpenCL/\1\"|g" -i "$f"
      sed "s|#define COMPARE_\([SM]\) \"\(.*\.cl\)\"|#define COMPARE_\1 \"$out/share/hashcat/OpenCL/\2\"|g" -i "$f"
    done
  '';

<<<<<<< HEAD
  postFixup = let
    LD_LIBRARY_PATH = builtins.concatStringsSep ":" ([
      "${ocl-icd}/lib"
    ] ++ lib.optionals cudaSupport [
      "${cudaPackages.cudatoolkit}/lib"
    ]);
  in ''
    wrapProgram $out/bin/hashcat \
      --prefix LD_LIBRARY_PATH : ${lib.escapeShellArg LD_LIBRARY_PATH}
  '' + lib.optionalString cudaSupport ''
    for program in $out/bin/hashcat $out/bin/.hashcat-wrapped; do
      isELF "$program" || continue
      addOpenGLRunpath "$program"
    done
=======
  postFixup = ''
    wrapProgram $out/bin/hashcat --prefix LD_LIBRARY_PATH : ${ocl-icd}/lib
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "Fast password cracker";
    homepage    = "https://hashcat.net/hashcat/";
    license     = licenses.mit;
<<<<<<< HEAD
    platforms   = platforms.unix;
    maintainers = with maintainers; [ felixalbrigtsen kierdavis zimbatm ];
=======
    platforms   = platforms.linux;
    maintainers = with maintainers; [ kierdavis zimbatm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
