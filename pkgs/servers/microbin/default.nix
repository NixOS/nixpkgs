{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "microbin";
  version = "1.2.1";

  # The GitHub source is outdated
  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OLg0ejs9nanMNlY0lcnJ/RoRwefrXEaaROwx5aPx4u8=";
  };

  cargoHash = "sha256-XdHP0XruqtyLyGbLHielnmTAc3ZgeIyyZnknO+5k4Xo=";

  meta = with lib; {
    description = "A tiny, self-contained, configurable paste bin and URL shortener written in Rust";
    homepage = "https://github.com/szabodanika/microbin";
    changelog = "https://github.com/szabodanika/microbin/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya figsoda ];
  };
}
