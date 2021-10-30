{ lib, stdenv, fetchFromGitHub, cmake, python3, spirv-headers }:

stdenv.mkDerivation rec {
  pname = "spirv-tools";
  # Update spirv-headers rev in lockstep according to DEPs file
  version = "2020.2";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "v${version}";
    sha256 = "00b7xgyrcb2qq63pp3cnw5q1xqx2d9rfn65lai6n6r89s1vh3vg6";
  };

  nativeBuildInputs = [ cmake python3 ];

  cmakeFlags = [ "-DSPIRV-Headers_SOURCE_DIR=${spirv-headers.src}" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "The SPIR-V Tools project provides an API and commands for processing SPIR-V modules";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
