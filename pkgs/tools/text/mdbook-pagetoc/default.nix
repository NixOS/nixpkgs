{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-pagetoc";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "slowsage";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-g7UaQZzIdpv4hZgEtoJ6fyPgA9yQPw3LiATwngjHnWE=";
  };

  cargoHash = "sha256-qSsZaXneGW6zspgy8wHFZvRyTexy6VdySleZv0ieBsI=";

  meta = with lib; {
    description = "Table of contents for mdbook (in sidebar)";
    mainProgram = "mdbook-pagetoc";
    homepage = "https://github.com/slowsage/mdbook-pagetoc";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
