{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.8";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "sha256-MdkKDjyePlu6nDyHM9qdhn+kFeXZnyfin+cIZkE+PRE=";
  };

  cargoSha256 = "sha256-MaN0Zz1cQQvwA6rPJRqzI4Q8gniHKAsROLsc0tBpYYU=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang-nursery/mdbook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
  };
}
