{ lib
, fetchCrate
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "vopono";
  version = "0.8.6";

  src = fetchCrate {
    inherit pname version;
    sha256 = "0dsyav755mggnsybj7iwvdqbqzz0gfd3j9vh0hmg5b7pbffanzvy";
  };

  cargoHash = "sha256:187mi36dgr2f1klqclci175zqgyrm0b6awrcnav63vira7hqz076";

  meta = with lib; {
    description = "Run applications through VPN connections in network namespaces";
    homepage = "https://github.com/jamesmcm/vopono";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
