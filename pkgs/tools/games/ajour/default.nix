{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  autoPatchelfHook,
  cmake,
  makeWrapper,
  pkg-config,
  python3,
  expat,
  freetype,
  kdialog,
  zenity,
  openssl,
  libglvnd,
  libX11,
  libxcb,
  libXcursor,
  libXi,
  libxkbcommon,
  libXrandr,
  vulkan-loader,
  wayland,
}:

let
  rpathLibs = [
    libglvnd
    libXcursor
    libXi
    libxkbcommon
    libXrandr
    libX11
    vulkan-loader
    wayland
  ];

in
rustPlatform.buildRustPackage rec {
  pname = "ajour";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "casperstorm";
    repo = "ajour";
    rev = version;
    sha256 = "sha256-oVaNLclU0EVNtxAASE8plXcC+clkwhBeb9pz1vXufV0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "iced-0.3.0" = "sha256-cPQ0qqcdCMx2agSpAKSvVDBEoF/vUffGg1UkX85KmfY=";
    };
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    makeWrapper
    pkg-config
    python3
  ];

  buildInputs = [
    expat
    freetype
    openssl
    libxcb
    libX11
    libxkbcommon
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r resources/logo $out/share/icons
    install -Dm444 resources/linux/ajour.desktop -t $out/share/applications
  '';

  fixupPhase = ''
    patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}:$(patchelf --print-rpath $out/bin/ajour)" $out/bin/ajour
    wrapProgram $out/bin/ajour --prefix PATH ":" ${
      lib.makeBinPath [
        zenity
        kdialog
      ]
    }
  '';

  meta = with lib; {
    description = "World of Warcraft addon manager written in Rust";
    mainProgram = "ajour";
    longDescription = ''
      Ajour is a World of Warcraft addon manager written in Rust with a
      strong focus on performance and simplicity. The project is
      completely advertisement free, privacy respecting and open source.
    '';
    homepage = "https://github.com/casperstorm/ajour";
    changelog = "https://github.com/casperstorm/ajour/blob/master/CHANGELOG.md";
    license = licenses.mit;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ hexa ];
  };
}
