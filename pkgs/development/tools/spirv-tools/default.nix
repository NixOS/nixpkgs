{ stdenv, fetchFromGitHub, cmake, python, spirv-headers }:
let
  # Update spirv-headers rev in lockstep according to DEPs file
  version = "2019.1";
in

assert version == spirv-headers.version;
stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "v${version}";
    sha256 = "0vddjzhkrhrm3l3i57nxmq2smv3r1s0ka5ff2kziaahr4hqb479r";
  };
  enableParallelBuilding = true;

  buildInputs = [ cmake python ];

  cmakeFlags = [ "-DSPIRV-Headers_SOURCE_DIR=${spirv-headers.src}" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "The SPIR-V Tools project provides an API and commands for processing SPIR-V modules";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.ralith ];
  };
}
