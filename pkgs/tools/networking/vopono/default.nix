{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.8.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0kpkvnw12cvcswsx2p8xicyn57i5fd7p5d7n1dqq9x18q6am181p";
  };

  cargoHash = "sha256:1y07iazb7rwgs0viwn81qmwbcnxza9n89w2jh0r4fq98rr337081";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
