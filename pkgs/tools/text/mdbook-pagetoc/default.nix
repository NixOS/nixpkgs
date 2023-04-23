{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pagetoc";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "slowsage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rhg/QDdO44Qwb/z1tQEYK5DcGuUI6cQvpHTYmqYyoWY=";
  };

  cargoHash = "sha256-03/bLFbP+BSfRW6wyg7LnryDP0kqvfvYqrFBKFZ2xY8=";

  meta = with lib; {
    description = "Table of contents for mdbook (in sidebar)";
    homepage = "https://github.com/slowsage/mdbook-pagetoc";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
