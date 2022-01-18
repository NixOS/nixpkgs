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
  version = "0.6.0";

  src = fetchFromGitLab {
    owner = "Veloren";
    repo = "airshipper";
    rev = "v${version}";
    sha256 = "sha256-m3H2FE1DoV/uk9PGgf9PCagwmWWSQO/gCi7zpS02/WY=";
  };

  cargoSha256 = "sha256-ddy4TjT/ia+sLBnpwcXBVUzAS07ar+Jjc04KS5/arlU=";

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
