{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.9";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-j8o9UxyBE7uML/7gw9UYbXLNYK9ka2jhUw5/v7pxIc8=";
  };

  cargoHash = "sha256-foJSaifllpGNMfxWMGm4BWwItOdtAmUcaOO1j1JMCpo=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
    mainProgram = "vopono";
  };
}
