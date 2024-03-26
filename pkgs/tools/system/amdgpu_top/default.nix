{ lib
, rustPlatform
, fetchFromGitHub
, libdrm
, libX11
, libGL
, wayland
, wayland-protocols
, libxkbcommon
, libXrandr
, libXi
, libXcursor
}:

rustPlatform.buildRustPackage rec {
  pname = "amdgpu_top";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Umio-Yasuno";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8fEYIrBh+O+bL3szKHvAD+wBTY+ScxBZvjpNufmfYYA=";
  };

  cargoLock = {
    outputHashes = {
      "libdrm_amdgpu_sys-0.5.0" = "sha256-Sqq3Qnt6hMUubhVgetFCPMFqRrcJuGDT9V4ZRaNgcpQ=";
    };
    lockFile = ./Cargo.lock;
  };

  buildInputs = [
    libdrm
    libX11
    libGL
    wayland
    wayland-protocols
    libxkbcommon
    libXrandr
    libXi
    libXcursor
  ];

  postInstall = ''
    install -D ./assets/${pname}.desktop -t $out/share/applications/
  '';

  postFixup = ''
    patchelf --set-rpath "${lib.makeLibraryPath buildInputs}" $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Tool to display AMDGPU usage";
    homepage = "https://github.com/Umio-Yasuno/amdgpu_top";
    changelog = "https://github.com/Umio-Yasuno/amdgpu_top/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ geri1701 ];
    platforms = platforms.linux;
    mainProgram = "amdgpu_top";
  };
}
