{ stdenv, fetchFromGitHub, cmake, python }:

let

spirv_sources = {
  # `glslang` requires a specific version of `spirv-tools` and `spirv-headers` as specified in `known-good.json`.
  tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "1a283f41ed09e31cd720744f904af3d823ceddbf";
    sha256 = "1z65wglg081pri9rmiyydvppgd67qr269ppphy4yhg2wg81gg72c";
  };
  headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "ff684ffc6a35d2a58f0f63108877d0064ea33feb";
    sha256 = "0ypjx61ksr6vda2iy3kxhyjia5qxf0x4qa4jij0giw9x5rsnga6g";
  };
};

in

stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  version = "2018-07-04";

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
