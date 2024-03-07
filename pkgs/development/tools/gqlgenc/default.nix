{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-XNmCSkgJJ2notrv0Din4jlU9EoHJcznjEUiXQgQ5a7I=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-6iwNykvW1m+hl6FzMNbvvPpBNp8OQn2/vfJLmAj60Mw=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ milran ];
  };
}
