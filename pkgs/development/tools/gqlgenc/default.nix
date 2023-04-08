{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "gqlgenc";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "yamashou";
    repo = "gqlgenc";
    rev = "v${version}";
    sha256 = "sha256-yMM6LR5Zviwr1OduSUxsSzdzrb+Lv5ILkVjXWD0b0FU=";
  };

  excludedPackages = [ "example" ];

  vendorHash = "sha256-d95w9cApLyYu+OOP4UM5/+4DDU2LqyHU8E3wSTW8c7Q=";

  meta = with lib; {
    description = "Go tool for building GraphQL client with gqlgen";
    homepage = "https://github.com/Yamashou/gqlgenc";
    license = licenses.mit;
    maintainers = with maintainers; [ milran ];
  };
}
