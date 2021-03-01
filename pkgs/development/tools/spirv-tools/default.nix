{ lib, stdenv, fetchFromGitHub, cmake, python3, spirv-headers }:
let
  # Update spirv-headers rev in lockstep according to DEPs file
  version = "2020.7";
in

stdenv.mkDerivation rec {
  pname = "spirv-tools";
  inherit version;

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "v${version}";
    sha256 = "FCRCZ4jHMvcMJhpxKMQdYcIAauRHLqVIP2/5CLdXPkk=";
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
