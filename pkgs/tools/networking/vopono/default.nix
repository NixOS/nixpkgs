{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-LaUoaZhOA/3o5DyKqq17u3Sf+lvkxMXkkwMEf6YLnCI=";
  };

  cargoHash = "sha256-Aef0A+4de3vWlK2zOmUmcGGO6XD1DNYwcZ1ryIvo7mM=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
