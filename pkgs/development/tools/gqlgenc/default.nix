{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.25.1";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-i2+J8hWbADeOmua4I3/NX8MC6FKP+5I9BqwCDkLOnvw=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-/lrOc2suNyNRlpi22QUr6MZCIrdWaWiZUv6pe/mYnB8=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ milran ];
  };
}
