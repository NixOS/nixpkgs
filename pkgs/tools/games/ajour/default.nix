{ lib
, fetchFromGitHub
, rustPlatform
, autoPatchelfHook
, cmake
, makeWrapper
, pkg-config
, python3
, expat
, freetype
, kdialog
, zenity
, openssl
, libX11
, libxcb
, libXcursor
, libXi
, libxkbcommon
, libXrandr
, vulkan-loader
, wayland
}:

let
  rpathLibs = [
    libXcursor
    libXi
    libxkbcommon
    libXrandr
    libX11
    vulkan-loader
    wayland
  ];

in rustPlatform.buildRustPackage rec {
  pname = "Ajour";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "casperstorm";
    repo = "ajour";
    rev = version;
    sha256 = "sha256-u48U4WGlrSl8T3YF7cjApyjNaUI4YyyHEy0TgJw7r/Y=";
  };

  cargoSha256 = "sha256-Hdid70AB4AKtSsQBsr6K/de4nvI3rvghEWIwM7mpRIA=";

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
  ];

  fixupPhase = ''
    patchelf --set-rpath "${lib.makeLibraryPath rpathLibs}:$(patchelf --print-rpath $out/bin/ajour)" $out/bin/ajour
    wrapProgram $out/bin/ajour --prefix PATH ":" ${lib.makeBinPath [ zenity kdialog ]}
  '';

  meta = with lib; {
    description = "World of Warcraft addon manager written in Rust";
    longDescription = ''
      Ajour is a World of Warcraft addon manager written in Rust with a
      strong focus on performance and simplicity. The project is
      completely advertisement free, privacy respecting and open source.
    '';
    homepage = "https://github.com/casperstorm/ajour";
    changelog = "https://github.com/casperstorm/ajour/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
