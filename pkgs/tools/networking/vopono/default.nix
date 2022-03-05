{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.8.10";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-+ZRvuUA7BvM8YW1QZQ7iJrLvleitl1hqEOrTkrLVSes";
  };

  cargoHash = "sha256-zM5JufS0qEYPEEwl6iPZYge3cssrsLu835AhAd8F3vc";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
