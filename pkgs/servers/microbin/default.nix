{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "microbin";
  version = "1.1.0";

  # GitHub sources do not have Cargo.lock
  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-gfEO7Rrzc4KSnSXFrMmGLrTXuZIUCdumt2N429nHPi8=";
  };

  cargoSha256 = "sha256-k/5CG8bf5RuO6K9mEj6seqV6AuWMqatBRDaSS0guhi0=";

  meta = with lib; {
    description = "A tiny, self-contained, configurable paste bin and URL shortener written in Rust";
    homepage = "https://github.com/szabodanika/microbin";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
