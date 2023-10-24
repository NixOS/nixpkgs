{ lib, udev, alsa-lib, vulkan-loader, xorg, libxkbcommon, wayland, pkg-config, makeWrapper, rustPlatform, fetchFromGitHub }:
let
  buildInputs = [
    udev alsa-lib vulkan-loader
    xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi
    libxkbcommon wayland
  ];
  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];
in rustPlatform.buildRustPackage {
  pname = "natural-pong";
  version = "0.1.0";
  cargoHash = "sha256-jfeQjZrGyGXQ298naakiDpSlbl116ZKyi0RBkLnlwsA=";

  buildInputs = buildInputs;
  nativeBuildInputs = nativeBuildInputs;
  LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;
  src = fetchFromGitHub {
    owner = "M0rious";
    repo = "3d-pong";
    rev = "3cbe82e080bf894622364a88322fc19b7b5fc447";
    hash = "sha256-0gQO5PX9vVcsGf3z2ikWtCNtuC1b855bLXMsvJRU23o=";
  };
  postInstall = ''
    mv $out/bin/pong $out/bin/natural-pong
    wrapProgram $out/bin/natural-pong \
      --set LD_LIBRARY_PATH $LD_LIBRARY_PATH \
      --set CARGO_MANIFEST_DIR $out/share/pong
    mkdir -p $out/share/pong
    cp -r $src/assets $out/share/pong/
  '';

  meta = with lib; {
    description = "A fresh looking pong game";
    license = licenses.mit;
    maintainers = [ maintainers.neosam ];
    platforms = platforms.linux;
  };
}
