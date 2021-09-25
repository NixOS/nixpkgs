{ lib
, rustPlatform
, fetchFromGitHub
, libclang
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.8.13";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0k88ma00gj8wjdvd7ysbbvqnf5sk1w8d3wqbi6qfxnqrc1k3hlv2";
  };

  cargoSha256 = "0mmk0igm2s8sxi65zvikxhz52xhkyd3ljqy61mij7zlx95rf639x";

  LIBCLANG_PATH = "${libclang.lib}/lib";

  checkFlags = [
    "--skip checker::hunspell::tests::hunspell_binding_is_sane"
  ];

  meta = with lib; {
    description = "Checks rust documentation for spelling and grammar mistakes";
    homepage = "https://github.com/drahnr/cargo-spellcheck";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ newam ];
  };
}
