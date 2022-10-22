{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-hbijcLX4CwnQVyM7XZneZH1pFEmZceN0ougltldyWnc=";
  };

  cargoHash = "sha256-FSgI6ZFRxl9uE1yA4LkdHcI2fymvMqkibxgTNTlJq5g=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
