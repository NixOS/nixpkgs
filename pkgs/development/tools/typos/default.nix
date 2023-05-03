{ fetchFromGitHub, rustPlatform, lib }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.14.8";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x7Pcg2zgu2s+oLkOJj+Eo/Gs48BJO6+JATckMqaeaj4=";
  };

  cargoHash = "sha256-4se9/lcVWAWhbi0i3FDGQraK5KhPZ6ongc2wmJV4gI0=";

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/crate-ci/typos/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
  };
}
