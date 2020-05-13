{ stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "monolith";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "Y2Z";
    repo = pname;
    rev = "v${version}";
    sha256 = "0w19szxzhwxbgnv4k618p8v29dhbar1fn433bsz1cr1apnrahmkn";
  };

  cargoSha256 = "06gc3cpx1m2f6fwrm8brw5nidg1v02q1qwqfxvv3xzmmczbw4345";

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
