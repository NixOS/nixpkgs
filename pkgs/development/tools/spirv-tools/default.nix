{ stdenv, fetchFromGitHub, cmake, python }:

let

spirv_sources = {
  # `vulkan-loader` requires a specific version of `spirv-tools` and `spirv-headers` as specified in
  # `<vulkan-loader-repo>/spirv-tools_revision`.
  tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "37422e9dba1a3a8cb8028b779dd546d43add6ef8";
    sha256 = "0sp2p4wg902clq0fr94vj19vyv43cq333jjxr0mjzay8dw2h4yzk";
  };
  headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "c470b68225a04965bf87d35e143ae92f831e8110";
    sha256 = "18jgcpmm0ixp6314r5w144l3wayxjkmwqgx8dk5jgyw36dammkwd";
  };
};

in

stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  version = "2016-12-19";

  src = spirv_sources.tools;
  patchPhase = ''ln -sv ${spirv_sources.headers} external/spirv-headers'';
  enableParallelBuilding = true;

  buildInputs = [ cmake python ];

  passthru = {
    headers = spirv_sources.headers;
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "The SPIR-V Tools project provides an API and commands for processing SPIR-V modules";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
