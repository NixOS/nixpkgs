{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-D+yROQidu+a3qzCNrVxn0RNutIHNcIjMSNqPLHwA+zA=";
  };

  cargoHash = "sha256-oKoSHjABtaJYGyJ/G0zXC42XpXiUXwdPsOhyL1+D3GI=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
