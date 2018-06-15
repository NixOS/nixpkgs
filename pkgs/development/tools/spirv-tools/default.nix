{ stdenv, fetchFromGitHub, cmake, python }:

let

spirv_sources = {
  # `glslang` requires a specific version of `spirv-tools` and `spirv-headers` as specified in `known-good.json`.
  tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "9e19fc0f31ceaf1f6bc907dbf17dcfded85f2ce8";
    sha256 = "1zpwznq0fyvkzs5h9nnkr7g6svr0w8z6zx62xgnss17c2a5cz0lk";
  };
  headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "ce309203d7eceaf908bea8862c27f3e0749f7d00";
    sha256 = "1sv1iy2d46sg7r3xy591db6fn9h78wd079yvfa87vwmwsdkhiqhm";
  };
};

in

stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  version = "2018-02-05";

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
