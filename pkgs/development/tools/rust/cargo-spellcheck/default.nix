{ lib
, rustPlatform
, fetchFromGitHub
, libclang
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-spellcheck";
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "drahnr";
    repo = pname;
    rev = "v${version}";
    sha256 = "11r4gzcsbqlflam2rdixc451qw69c46mkf7g0slq6f127is25fgz";
  };

  cargoSha256 = "1p4iirblk6idvfhn8954v8lbxlzj0gbd8fv4wq03hfrdqisjqcsn";

  buildInputs = lib.optional stdenv.isDarwin Security;

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
