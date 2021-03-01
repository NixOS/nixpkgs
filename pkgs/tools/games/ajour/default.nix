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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "casperstorm";
    repo = "ajour";
    rev = version;
    sha256 = "1lwwj16q24k3d3vaj64zkai4cb15hxp6bzicp004q5az4gbriwih";
  };

  cargoSha256 = "17j6v796ahfn07yjj9xd9kygy0sllz93ac4gky8w0hcixdwjp3i5";

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
