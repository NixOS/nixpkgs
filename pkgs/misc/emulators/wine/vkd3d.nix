{ stdenv, fetchurl, vulkan-headers, spirv-headers, vulkan-loader }:

#TODO: MoltenVK
#TODO: unstable

stdenv.mkDerivation rec {
  pname = "vkd3d";
  version = "1.1";

  src = fetchurl {
    url = "https://dl.winehq.org/vkd3d/source/vkd3d-${version}.tar.xz";
    sha256 = "1dkayp95g1691w7n2yn1q9y7klq5xa921dgmn9a5vil0rihxqnj9";
  };

  buildInputs = [ vulkan-headers spirv-headers vulkan-loader ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A 3d library build on top on Vulkan with a similar api to DirectX 12";
    homepage = "https://source.winehq.org/git/vkd3d.git";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.marius851000 ];
  };
}
