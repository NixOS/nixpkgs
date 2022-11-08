{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "microbin";
  version = "1.2.0";

  # GitHub sources do not have Cargo.lock
  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-dZClslUTUchx+sOJzFG8wiAgyW/0RcCKfKYklKfVrzM=";
  };

  cargoSha256 = "sha256-fBbChu5iy/2H/8IYCwd1OwxplGPZAmkd8z8xD7Uc0vo=";

  meta = with lib; {
    description = "A tiny, self-contained, configurable paste bin and URL shortener written in Rust";
    homepage = "https://github.com/szabodanika/microbin";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dit7ya ];
  };
}
