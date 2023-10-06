{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.6";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-pxzWhaxihGQ6n6KyliiPK3YyVdUMP8OlJwT9Msna1OE=";
  };

  cargoHash = "sha256-pfZDnPWDjOaGov8jEdeyQdP9NWWES+9pSM5yGD31YB4=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
