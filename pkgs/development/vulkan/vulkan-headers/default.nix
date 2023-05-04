{ lib
, stdenv
, fetchFromGitHub
, cmake
, vulkanVersions
}:

stdenv.mkDerivation rec {
  pname = "vulkan-headers";
  version = vulkanVersions.vulkanVersion or vulkanVersions.sdkVersion;

  nativeBuildInputs = [ cmake ];

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Headers";
    rev = vulkanVersions.vulkanRev or vulkanVersions.sdkRev;
    hash = vulkanVersions.vulkanHeadersHash;
  };

  meta = with lib; {
    description = "Vulkan Header files and API registry";
    homepage = "https://www.lunarg.com";
    platforms = platforms.unix ++ platforms.windows;
    license = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
