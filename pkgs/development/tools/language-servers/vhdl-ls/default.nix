{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "vhdl-ls";
  version = "0.80.0";

  src = fetchFromGitHub {
    owner = "VHDL-LS";
    repo = "rust_hdl";
    rev = "v${version}";
    hash = "sha256-3p6SmmNnuPoHbA0QmfgvO342AhRx5dI9q4YXypi/2k0=";
  };

  cargoHash = "sha256-zAz33P5k6wmQej8u45+lXKHSRVaZhrB5L0jUPjs44W8=";

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
