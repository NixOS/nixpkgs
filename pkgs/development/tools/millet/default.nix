{ lib, rustPlatform, fetchFromGitHub, rustfmt }:

rustPlatform.buildRustPackage rec {
  pname = "millet";
  version = "0.1.14";

  src = fetchFromGitHub {
    owner = "azdavis";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kz2CwfntAUI33igYJBJQKPAmoW895toe/wS9dGnFB64=";
  };

  cargoSha256 = "sha256-Rrnt6VEp7jDGLSsDcHuPfKhkm4USstxi/OW5oOVrgqY=";

  nativeBuildInputs = [
    # Required for `syntax-gen` crate https://github.com/azdavis/language-util/blob/8ec2dc509c88951102ad3e751820443059a363af/crates/syntax-gen/src/util.rs#L37
    rustfmt
  ];

  cargoBuildFlags = [ "--package" "lang-srv" ];

  meta = with lib; {
    description = "A language server for Standard ML";
    homepage = "https://github.com/azdavis/millet";
    changelog = "https://github.com/azdavis/millet/raw/v${version}/docs/changelog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
