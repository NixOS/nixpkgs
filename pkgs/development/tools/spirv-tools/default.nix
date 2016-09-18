{ stdenv, fetchFromGitHub, cmake, python }:

let

spirv_sources = {
  # `vulkan-loader` requires a specific version of `spirv-tools` and `spirv-headers` as specified in
  # `<vulkan-loader-repo>/spirv-tools_revision`.
  tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "923a4596b44831a07060df45caacb522613730c9";
    sha256 = "0hmgng2sv34amfsag3ya09prnv1w535djwlzfn8h2vh430vgawxa";
  };
  headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "33d41376d378761ed3a4c791fc4b647761897f26";
    sha256 = "1s103bpi3g6hhq453qa4jbabfkyxxpf9vn213j8k4vm26lsi8hs2";
  };
};

in

stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  version = "2016-07-18";

  src = spirv_sources.tools;
  patchPhase = ''ln -sv ${spirv_sources.headers} external/spirv-headers'';
  enableParallelBuilding = true;

  buildInputs = [ cmake python ];

  passthru = {
    headers = spirv_sources.headers;
  };

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "The SPIR-V Tools project provides an API and commands for processing SPIR-V modules.";
  };
}
