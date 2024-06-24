{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "vhdl-ls";
  version = "0.81.0";

  src = fetchFromGitHub {
    owner = "VHDL-LS";
    repo = "rust_hdl";
    rev = "v${version}";
    hash = "sha256-iF8HIfxC7WM5YT85HfCTM5hu5yCFnHpDposGDAO3qJI=";
  };

  cargoHash = "sha256-hkmaMzeQLd3l6A3xyLAZk+MrEeUKPd7H2N4Nsz7nBmk=";

  postPatch = ''
    substituteInPlace vhdl_lang/src/config.rs \
      --replace /usr/lib $out/lib
  '';

  postInstall = ''
    mkdir -p $out/lib/rust_hdl
    cp -r vhdl_libraries $out/lib/rust_hdl
  '';

  meta = {
    description = "Fast VHDL language server";
    homepage = "https://github.com/VHDL-LS/rust_hdl";
    license = lib.licenses.mpl20;
    mainProgram = "vhdl_ls";
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
