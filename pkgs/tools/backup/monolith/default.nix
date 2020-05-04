{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    sha256 = "0am992dhqv0vpk4zsc9wwnbzhpdx98wm9dxi89bq2yr3l77lml3d";
  };

  cargoSha256 = "03nd8pzrd66rv12l7qr9i4kdrdr8hk1mz8ihvd982cjd2dlisipd";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  checkPhase = "cargo test -- --skip tests::cli";

  meta = with stdenv.lib; {
    description = "Bundle any web page into a single HTML file";
    homepage = "https://github.com/Y2Z/monolith";
    license = licenses.unlicense;
    maintainers = with maintainers; [ filalex77 ];
  };
}
