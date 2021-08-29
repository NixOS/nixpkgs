{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "mdBook";
    rev = "v${version}";
    sha256 = "sha256-51S4I1YIbdgXkhuT7KnhJe71nGCQmr9JmuGtp7Bcxqo=";
  };

  cargoSha256 = "sha256-4bYLrmyI7cPUes6DYREiIB9gDze0KO2jMP/jPzvWbwQ=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Create books from MarkDown";
    homepage = "https://github.com/rust-lang-nursery/mdbook";
    license = [ licenses.mpl20 ];
    maintainers = [ maintainers.havvy ];
  };
}
