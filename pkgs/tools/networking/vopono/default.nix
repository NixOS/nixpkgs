{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-iA445u0Xht7kg3jScb6OvYwji3PmE+WpeKCN+Mk7Dzo=";
  };

  cargoHash = "sha256-Y2sw2avmxUY1lHaYt/UX/Nz2BaCFQQ8dmetsVK4eCYc=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
