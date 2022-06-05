{ lib
, rustPlatform
, fetchFromGitLab
, fetchpatch
, openssl
, libGL
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

  patches = [
    # this *should* be merged in time for the release following 0.7.0
    (fetchpatch {
      url = "https://github.com/veloren/Airshipper/commit/97fc986ab4cbf59f2c764f647710f19db86031b4.patch";
      hash = "sha256-Sg5et+yP6Z44wV/t9zqKLpg1C0cq6rV+3WrzAH4Za3U=";
    })
  ];

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
    install -Dm444 -t "$out/share/applications" "client/assets/net.veloren.airshipper.desktop"
    install -Dm444    "client/assets/logo.ico"  "$out/share/icons/net.veloren.airshipper.ico"
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libGL
        vulkan-loader
        wayland
        wayland-protocols
        libxkbcommon
        libX11
        libXrandr
        libXi
        libXcursor
      ];
    in
    ''
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
