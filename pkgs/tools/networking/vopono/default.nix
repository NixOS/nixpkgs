{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.10.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-a9u8Ywxrdo4FFggotL8L5o5eDDu+MtcMVBG+jInXDVs=";
  };

  cargoHash = "sha256-oT74oj/6rKB1cuRiHnbc9QVUZQcDvvb4KZf09XuctNM=";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
