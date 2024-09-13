{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-4d2IFJIoIX0IlS/v/EJkn1cK8hJl9808PE8ZnwqYzu8=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-GcqLW/Ooy2h5spYA94/HmaG0yYiqA4g5DyKlg9EORCQ=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ milran ];
  };
}
