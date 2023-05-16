{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "vhdl-ls";
<<<<<<< HEAD
  version = "0.66.0";
=======
  version = "0.64.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "VHDL-LS";
    repo = "rust_hdl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tVeGfPm5WdZjARp7n4WD3YQzMUWA3M3TJo2oVivtkiA=";
  };

  cargoHash = "sha256-bXz216QvTpBuUNAi5sF0Lga+1ubjlokqPglUyAVXThg=";

  postPatch = ''
=======
    hash = "sha256-j5WRJJBUPKW3W+kY5hdqdZxxGkIAoEcW+A2pp23MX6Q=";
  };

  # No Cargo.lock upstream, see:
  # https://github.com/VHDL-LS/rust_hdl/issues/166
  cargoLock = {
    lockFile = ./Cargo.lock;
  };
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  ''
  # Also make it look up vhdl_libraries in an expected location
  + ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
