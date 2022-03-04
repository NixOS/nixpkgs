{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "ejson2env";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1nfMmjYKRo5vjOwLb3fX9SQ0CDHme1DAz0AGGpV4piI=";
  };

  vendorSha256 = "sha256-lais54Gm4UGJN8D+iFbP8utTfDr+v8qXZKLdpNKzJi8=";

  meta = with lib; {
    description = "A tool to simplify storing secrets that should be accessible in the shell environment in your git repo.";
    homepage = "https://github.com/Shopify/ejson2env";
    maintainers = with maintainers; [ viraptor ];
    license = licenses.mit;
  };
}
