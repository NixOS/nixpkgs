{ stdenv, fetchFromGitHub, cmake, python }:

let

spirv_sources = {
  # `vulkan-loader` requires a specific version of `spirv-tools` and `spirv-headers` as specified in
  # `<vulkan-loader-repo>/external_revisions/spirv-tools_revision`.
  tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "7fe8a57a5bd72094e91f9f93e51dac2f2461dcb4";
    sha256 = "0rh25y1k3m3f1nqs032lh3mng5qfw9kqn6xv9yzzm47i1i0b6hmr";
  };
  headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "6c08995e6e7b94129e6086c78198c77111f2f262";
    sha256 = "07m12wm9prib7hldj7pbc8vwnj0x6llgx4shzgy8x4xbhbafawws";
  };
};

in

stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  version = "2017-03-23";

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
