{ stdenv, fetchFromGitHub, cmake, python3, spirv-headers }:
let
  # Update spirv-headers rev in lockstep according to DEPs file
  version = "2019.4";
in

stdenv.mkDerivation rec {
  pname = "spirv-tools";
  inherit version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "v${version}";
    sha256 = "17bbvhk4p42x4jlvcr5p9903xiiryw57c8yyfxmqik10s8601an9";
  };
  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake python3 ];

  cmakeFlags = [ "-DSPIRV-Headers_SOURCE_DIR=${spirv-headers.src}" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "The SPIR-V Tools project provides an API and commands for processing SPIR-V modules";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
