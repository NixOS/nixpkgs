{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-edit";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "killercup";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mx01h2zv7mpyi8s1545b7hjxn9aslzpbngrq4ii9rfqznz3r8k9";
  };

  cargoSha256 = "sha256-zlYYW1obLBbpCdHaGHZc4jSQIu1zf2ibl7H/c0nxOsA=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl  ]
    ++ lib.optionals stdenv.isDarwin [ Security libiconv curl ];

  meta = with lib; {
    description =
      "A utility for managing cargo dependencies from the command line.";
    homepage = "https://github.com/killercup/cargo-edit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ humancalico ];
  };
}
