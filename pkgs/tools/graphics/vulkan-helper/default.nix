{ lib
, rustPlatform
, fetchFromGitHub
, vulkan-loader
, addOpenGLRunpath
}:

rustPlatform.buildRustPackage rec {
  pname = "vulkan-helper";
  version = "unstable-2023-12-22";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "vulkan-helper-rs";
    rev = "04b290c92febcfd6293fcf4730ce3bba55cd9ce0";
    hash = "sha256-2pLHnTn0gJKz4gfrR6h85LHOaZPrhIGYzQeci4Dzz2E=";
  };

  cargoSha256 = "sha256-OXMz1qu4/LDeQbwe7shhn2Eee15xKmBpWSsP0IbjoGM=";

  nativeBuildInputs = [
    addOpenGLRunpath
  ];

  postFixup = ''
    patchelf --add-rpath ${vulkan-loader}/lib $out/bin/vulkan-helper
    addOpenGLRunpath $out/bin/vulkan-helper
  '';

  meta = with lib; {
    description = "A simple CLI app used to interface with basic Vulkan APIs";
    homepage = "https://github.com/imLinguin/vulkan-helper-rs";
    license = licenses.mit;
    maintainers = with maintainers; [ aidalgol ];
    platforms = platforms.linux;
    mainProgram = "vulkan-helper";
  };
}
