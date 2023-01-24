{ lib
, stdenv
, fetchFromGitHub
, cmake
, simdExtensions ? null
}:

with rec {
  # SIMD instruction sets to compile for. If none are specified by the user,
  # an appropriate one is selected based on the detected host system
  isas = with stdenv.hostPlatform;
    if simdExtensions != null then lib.toList simdExtensions
    else if avx2Support then [ "AVX2" ]
    else if sse4_1Support then [ "SSE41" ]
    else if isx86_64 then [ "SSE2" ]
    else if isAarch64 then [ "NEON" ]
    else [ "NONE" ];

  archFlags = lib.optionals stdenv.hostPlatform.isAarch64 [ "-DARCH=aarch64" ];

  # CMake Build flags for the selected ISAs. For a list of flags, see
  # https://github.com/ARM-software/astc-encoder/blob/main/Docs/Building.md
  isaFlags = map ( isa: "-DISA_${isa}=ON" ) isas;

  # The suffix of the binary to link as 'astcenc'
  mainBinary = builtins.replaceStrings
    [ "AVX2" "SSE41"  "SSE2" "NEON" "NONE" "NATIVE" ]
    [ "avx2" "sse4.1" "sse2" "neon" "none" "native" ]
    ( builtins.head isas );
};

stdenv.mkDerivation rec {
  pname = "astc-encoder";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "ARM-software";
    repo = "astc-encoder";
    rev = version;
    sha256 = "sha256-FIskGHamKYYUtYmgwh7dS+bs2UPWIyBiviPkDAbVY+0=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = isaFlags ++ archFlags ++ [
    "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
  ];

  # Set a fixed build year to display within help output (otherwise, it would be 1980)
  postPatch = ''
    substituteInPlace Source/cmake_core.cmake \
      --replace 'string(TIMESTAMP astcencoder_YEAR "%Y")' 'set(astcencoder_YEAR "2022")'
  '';

  # Provide 'astcenc' link to main executable
  postInstall = ''
    ln -s $out/bin/astcenc-${mainBinary} $out/bin/astcenc
  '';

  meta = with lib; {
    homepage = "https://github.com/ARM-software/astc-encoder";
    description = "An encoder for the ASTC texture compression format";
    longDescription = ''
      The Adaptive Scalable Texture Compression (ASTC) format is
      widely supported by mobile and desktop graphics hardware and
      provides better quality at a given bitrate compared to ETC2.

      This program supports both compression and decompression in LDR
      and HDR mode and can read various image formats. Run `astcenc
      -help` to see all the options.
    '';
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ dasisdormax ];
    broken = !stdenv.is64bit;
  };
}
