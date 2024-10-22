{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.25.2";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-g+l493Nt0SuW4gwJh0s9Zeejpyx2oLxVDykIvBup638=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-YGFMQrxghJIgmiwEPfEqaACH7OETVkD8O7oUhm9foJo=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    mainProgram = "gqlgenc";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ milran ];
  };
}
