{ lib, stdenv
, addDriverRunpath
, config
, cudaPackages ? {}
, cudaSupport ? config.cudaSupport
, fetchurl
, makeWrapper
, opencl-headers
, ocl-icd
, xxHash
, Foundation, IOKit, Metal, OpenCL, libiconv
}:

stdenv.mkDerivation rec {
  pname   = "hashcat";
  version = "6.2.6";

  src = fetchurl {
    url = "https://hashcat.net/files/hashcat-${version}.tar.gz";
    sha256 = "sha256-sl4Qd7zzSQjMjxjBppouyYsEeyy88PURRNzzuh4Leyo=";
  };

  postPatch = ''
     # MACOSX_DEPLOYMENT_TARGET is defined by the enviroment
     # Remove hardcoded paths on darwin
    substituteInPlace src/Makefile \
      --replace "export MACOSX_DEPLOYMENT_TARGET" "#export MACOSX_DEPLOYMENT_TARGET" \
      --replace "/usr/bin/ar" "ar" \
      --replace "/usr/bin/sed" "sed" \
      --replace '-i ""' '-i'
  '';

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals cudaSupport [
    addDriverRunpath
  ];

  buildInputs = [ opencl-headers xxHash ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation IOKit Metal OpenCL libiconv ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "COMPTIME=1337"
    "VERSION_TAG=${version}"
    "USE_SYSTEM_OPENCL=1"
    "USE_SYSTEM_XXHASH=1"
  ] ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform == stdenv.buildPlatform) [
    "IS_APPLE_SILICON='${if stdenv.hostPlatform.isAarch64 then "1" else "0"}'"
  ];

  enableParallelBuilding = true;

  preFixup = ''
    for f in $out/share/hashcat/OpenCL/*.cl; do
      # Rewrite files to be included for compilation at runtime for opencl offload
      sed "s|#include \"\(.*\)\"|#include \"$out/share/hashcat/OpenCL/\1\"|g" -i "$f"
      sed "s|#define COMPARE_\([SM]\) \"\(.*\.cl\)\"|#define COMPARE_\1 \"$out/share/hashcat/OpenCL/\2\"|g" -i "$f"
    done
  '';

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
      addDriverRunpath "$program"
    done
  '';

  meta = with lib; {
    description = "Fast password cracker";
    mainProgram = "hashcat";
    homepage    = "https://hashcat.net/hashcat/";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ felixalbrigtsen zimbatm ];
  };
}
