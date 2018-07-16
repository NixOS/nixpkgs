{ stdenv, fetchFromGitHub, cmake, python }:

let

spirv_sources = {
  # `glslang` requires a specific version of `spirv-tools` and `spirv-headers` as specified in `known-good.json`.
  tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "f2c93c6e124836797311facb8449f9a0b76fefc2";
    sha256 = "03w5xk2hjijj1rfbx5dw3lhy7vb9zrssfcwvp09q47f77vkgl105";
  };
  headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "12f8de9f04327336b699b1b80aa390ae7f9ddbf4";
    sha256 = "0fswk5ndvkmy64har3dmhpkv09zmvb0p4knbqc4fdl4qiggz0fvf";
  };
};

in

stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  version = "2018-06-06";

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
    maintainers = [ maintainers.ralith ];
  };
}
