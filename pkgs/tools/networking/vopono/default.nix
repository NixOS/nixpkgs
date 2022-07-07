{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-89Mzn2knClBJwVlCglR5BOOo5dXRP1Gqp/mmwHvwM3c=";
  };

  cargoHash = "sha256-8m/zlmeYcYCxycP9W6eweRJ2Vf/8+GSYf+NNz3NtnIw=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
