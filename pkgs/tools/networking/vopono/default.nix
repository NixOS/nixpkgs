{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-6fK4A7/Ezi6MZxDec565g2LnDkTyGgQhiqzZznwG3s8=";
  };

  cargoHash = "sha256-lNBmX8UyGPQARjxYF9ECzVfgDtqXdHyB4GvjCgXoiLo=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
