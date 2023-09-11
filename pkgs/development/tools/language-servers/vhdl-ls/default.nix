{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "vhdl-ls";
  version = "0.66.0";

  src = fetchFromGitHub {
    owner = "VHDL-LS";
    repo = "rust_hdl";
    rev = "v${version}";
    hash = "sha256-tVeGfPm5WdZjARp7n4WD3YQzMUWA3M3TJo2oVivtkiA=";
  };

  cargoHash = "sha256-bXz216QvTpBuUNAi5sF0Lga+1ubjlokqPglUyAVXThg=";

  postPatch = ''
    substituteInPlace vhdl_lang/src/config.rs \
      --replace /usr/lib $out/lib
  '';

  postInstall = ''
    mkdir -p $out/lib/rust_hdl
    cp -r vhdl_libraries $out/lib/rust_hdl
  '';

  meta = {
    description = "A fast VHDL language server";
    homepage = "https://github.com/VHDL-LS/rust_hdl";
    license = lib.licenses.mpl20;
    mainProgram = "vhdl_ls";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
