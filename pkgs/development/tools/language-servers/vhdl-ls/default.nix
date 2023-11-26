{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "vhdl-ls";
  version = "0.67.0";

  src = fetchFromGitHub {
    owner = "VHDL-LS";
    repo = "rust_hdl";
    rev = "v${version}";
    hash = "sha256-3ixU1OWRgDNG4aFAZTqqTSt1Hw41mB+mScVsozA01gM=";
  };

  cargoHash = "sha256-SDXWFb0SDMqAmKrPOUryiMgPxv0yffcrqFVvFt4VPS4=";

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
