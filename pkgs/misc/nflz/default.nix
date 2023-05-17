{ fetchCrate
, lib
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "nflz";
  version = "1.0.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-c9+79zrIU/M1Rh+DiaLJzbrNSa4IKrYk1gP0dsabUiw=";
  };

  cargoHash = "sha256-+SOoZFVJ6mASRKufQE4JmHGKR5rbBgg1PmCrI6dvvko=";

  # Tests do not work in the package published on crates.io, since the folder
  # with test resources is not packaged.
  doCheck = false;

  meta = {
    description = "Numbered Files Leading Zeros helps you to manage ascending numbered file names";
    longDescription = ''
      CLI to add leading zeros to ascending numbered file names.
      NFLZ stands for Numbered Files Leading Zeros.

      This library helps you to manage files inside your file system that
      belong to a set of ordered files. An example are photos from a camera.
    '';
    homepage = "https://github.com/phip1611/nflz";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ phip1611 ];
  };
}
