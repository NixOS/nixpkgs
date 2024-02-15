{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-V2YKRRJP1KQDo0oIoKU3g/3H1Xeo2oLg3arCDU6NMto=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-lJ3oYDW7BJnguIJ/TzZSUgSuoDIKmb6hdXOKENtmk6M=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ milran ];
  };
}
