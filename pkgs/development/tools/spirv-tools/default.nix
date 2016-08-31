{ stdenv, fetchFromGitHub, cmake, python }:

let

spirv_sources = {
  # `vulkan-loader` requires a specific version of `spirv-tools` as specified
  # in `<vulkan-loader-repo>/spirv-tools_revision`.
  tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "1a9385bbd0e6eae188c14302cf37c415ecc8b698";
    sha256 = "12a2wyxhsnms966s12x9bkz2kh478qf9ygglzkxkd83j5fvmvzwm";
  };
  headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "3814effb879ab5a98a7b9288a4b4c7849d2bc8ac";
    sha256 = "1wfszfsx318i0gavwk0w1klg4wiav8g4q4qpraqgm69arasfb9gh";
  };
};

in

stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  version = "2016-07-18";

  src = spirv_sources.tools;
  patchPhase = ''ln -sv ${spirv_sources.headers} external/spirv-headers'';

  buildInputs = [ cmake python ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "The SPIR-V Tools project provides an API and commands for processing SPIR-V modules.";
  };
}
