{ lib
, stdenv
, rustPlatform
, fetchCrate
, pkg-config
, cmake
, fontconfig
, libGL
, xorg
, libxkbcommon
, wayland
  # Darwin Frameworks
, AppKit
, CoreGraphics
, CoreServices
, CoreText
, Foundation
, libiconv
, OpenGL
}:

let
  rpathLibs = [ fontconfig libGL xorg.libxcb xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi ]
    ++ lib.optionals stdenv.isLinux [ libxkbcommon wayland ];
in
rustPlatform.buildRustPackage rec {
  pname = "slint-lsp";
  version = "0.3.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-M4rd7179hpQW8jqjCY9ce64AhE6YWOC32tJg3v+00bo=";
  };

  cargoHash = "sha256-3HcgnC2PQUyINm2gjxzqbCicvcGvpYtQn1p3qnqBzjc=";

  nativeBuildInputs = [ cmake pkg-config fontconfig ];
  buildInputs = rpathLibs ++ [ xorg.libxcb.dev ]
    ++ lib.optionals stdenv.isDarwin [
    AppKit
    CoreGraphics
    CoreServices
    CoreText
    Foundation
    libiconv
    OpenGL
  ];

  postInstall = lib.optionalString stdenv.isLinux  ''
    patchelf --set-rpath ${lib.makeLibraryPath rpathLibs} $out/bin/slint-lsp
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = "Language Server Protocol (LSP) for Slint UI language";
    homepage = "https://slint-ui.com/";
    changelog = "https://github.com/slint-ui/slint/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ xgroleau ];
  };
}
