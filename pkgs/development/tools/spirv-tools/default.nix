{ stdenv, fetchFromGitHub, cmake, python }:

let

spirv_sources = {
  # `glslang` requires a specific version of `spirv-tools` and `spirv-headers` as specified in `known-good.json`.
  tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "9bfe0eb25e3dfdf4f3fd86ab6c0cda009c9bd661";
    sha256 = "1spfii4zib1lmz40vnz1d1cr6is7q2n7rvar1vfzi33gwrn8rqhi";
  };
  headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "d5b2e1255f706ce1f88812217e9a554f299848af";
    sha256 = "18530mpa030ckjhn78z9vbfd35l5jgh3mg22ra6k8gw8zx4wjhsl";
  };
};

in

stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  version = "2018-09-20";

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
