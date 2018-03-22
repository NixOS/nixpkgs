{ stdenv, fetchFromGitHub, cmake, python }:

let

spirv_sources = {
  # `vulkan-loader` requires a specific version of `spirv-tools` and `spirv-headers` as specified in
  # `<vulkan-loader-repo>/external_revisions/spirv-tools_revision`.
  tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "7e2d26c77b606b21af839b37fd21381c4a669f23";
    sha256 = "1nlzj081v1xdyfz30nfs8hfcnqd072fra127h46gav179f04kss2";
  };
  headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "2bb92e6fe2c6aa410152fc6c63443f452acb1a65";
    sha256 = "1rgjd7kpa7xpbwpzd6m3f6yq44s9xn5ddhz135213pxwbi5c0c26";
  };
};

in

stdenv.mkDerivation rec {
  name = "spirv-tools-${version}";
  version = "2017-09-01";

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
