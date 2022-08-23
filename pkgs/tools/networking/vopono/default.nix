{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-JwtiqY56Cn2oY5lRz/oxmQe2rw4spFvCOp1zKKuVsys=";
  };

  cargoHash = "sha256-NvdgyFlZ2udoWikJI7kzY14rfQi0KxpI2/P0+O5dqVA=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
