{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "handlr";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f4gmlqzgw1r8n0w9dr9lpsn94f2hlnak9bbq5xgf6jwgc9mwqzg";
  };

  cargoSha256 = "16d4dywwkgvvxw6ninrx87rqhx0whdq3yy01m27qjy4gz6z6ad8p";

  # Most tests fail (at least some due to directory permissions)
  doCheck = false;

  meta = with lib; {
    description = "Alternative to xdg-open to manage default applications with ease";
    homepage = "https://github.com/chmln/handlr";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
