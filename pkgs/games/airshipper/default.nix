{ lib
, rustPlatform
, fetchFromGitLab
, openssl
, vulkan-loader
, wayland
, wayland-protocols
, libxkbcommon
, libX11
, libXrandr
, libXi
, libXcursor
, pkg-config
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "airshipper";
  version = "0.7.0";

  src = fetchFromGitLab {
    owner = "Veloren";
    repo = "airshipper";
    rev = "v${version}";
    sha256 = "sha256-nOE9ZNHxLEAnMkuBSpxmeq3DxkRIlcoase6AxU+eFug=";
  };

  cargoSha256 = "sha256-s3seKVEhXyOVlt3a8cubzRWoB4SVQpdCmq12y0FpDUw=";

  buildInputs = [
    openssl
    wayland
    wayland-protocols
    libxkbcommon
    libX11
    libXrandr
    libXi
    libXcursor
  ];
  nativeBuildInputs = [ pkg-config makeWrapper ];

  postInstall = ''
    mkdir -p "$out/share/applications" && mkdir -p "$out/share/icons"
    cp "client/assets/net.veloren.airshipper.desktop" "$out/share/applications"
    cp "client/assets/logo.ico" "$out/share/icons/net.veloren.airshipper.ico"
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        vulkan-loader
        wayland
        wayland-protocols
        libxkbcommon
        libX11
        libXrandr
        libXi
        libXcursor
      ];
    in ''
      patchelf --set-rpath "${libPath}" "$out/bin/airshipper"
    '';

  doCheck = false;
  cargoBuildFlags = [ "--package" "airshipper" ];
  cargoTestFlags = [ "--package" "airshipper" ];

  meta = with lib; {
    description = "Provides automatic updates for the voxel RPG Veloren.";
    homepage = "https://www.veloren.net";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yusdacra ];
  };
}
