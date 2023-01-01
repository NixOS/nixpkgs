{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "star-history";
  version = "1.0.7";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-Cn05HX4GbHTwMwWxP3x0EtDEFqmn93eA+g4AXFFNNgE=";
  };

  cargoSha256 = "sha256-UnlTpuYoyvu3MK87zogwzmKhGJwIENws1Ak4VYnfTBI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Command line program to generate a graph showing number of GitHub stars of a user, org or repo over time";
    homepage = "https://github.com/dtolnay/star-history";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
