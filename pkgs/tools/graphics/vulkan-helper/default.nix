{ lib
, rustPlatform
, fetchFromGitHub
, vulkan-loader
, addOpenGLRunpath
}:

rustPlatform.buildRustPackage rec {
  pname = "vulkan-helper";
  version = "unstable-2023-09-16";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "vulkan-helper-rs";
    rev = "d65b1a17a11ec20670c77d8da02e68d388ed0888";
    hash = "sha256-usbYNalA0r09LXR6eV2e/T1eMNV4LnhzYLzPJQ6XNKQ=";
  };

  cargoSha256 = "sha256-fgB0vlbOhzGV1Sj180GCuTGZlVpAUlBUMAfsrG2FiuA=";

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
  };
}
