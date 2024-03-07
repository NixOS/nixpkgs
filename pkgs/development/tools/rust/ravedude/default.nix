{ lib
, rustPlatform
, fetchCrate
, pkg-config
, udev
, nix-update-script
, testers
, ravedude
}:

rustPlatform.buildRustPackage rec {
  pname = "ravedude";
  version = "0.1.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LhPRz3DUMDoe50Hq3yO+2BHpyh5fQ4sMNGLttjkdSZw=";
  };

  cargoHash = "sha256-Uo8wlTAHBkn/WeGPhPP+BU80wjSyNHsWQj8QvA7mHrk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ udev ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = ravedude;
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "Tool to easily flash code onto an AVR microcontroller with avrdude";
    homepage = "https://crates.io/crates/ravedude";
    license = with licenses; [ mit /* or */ asl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ rvarago ];
    mainProgram = "ravedude";
  };
}
