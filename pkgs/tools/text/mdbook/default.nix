{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "sha256-cS2fME3X8bFmEz6czoL+2ZFbflJP58+lIeC5SVleCNg=";
  };

  cargoSha256 = "sha256-iuJyprLp6HofcdH0NgNK2Vl+1FtdAvZPcltPUb5B2XU=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang-nursery/mdbook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
  };
}
