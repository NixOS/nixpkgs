{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "sfz";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "weihanglo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mKH1vgk+3tZEnjJRkfa0dDR383VN1VLNd3HEzC7f8YI=";
  };

  cargoHash = "sha256-MgbK39xAr8g9F+1MXZiw5rE/PsgQPcLZ2ZV6LiQbA24=";

  # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  doCheck = false;

  meta = with lib; {
    description = "Simple static file serving command-line tool written in Rust";
    homepage = "https://github.com/weihanglo/sfz";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "sfz";
  };
}
