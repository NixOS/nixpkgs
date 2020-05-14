{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = "${version}";
    sha256 = "1gn7q6wg7byhr1l5ly60rbb700xrww9slbq7gbxbw5c1fl0pp3yk";
  };

  vendorSha256 = "1w5hsdmi95v7qj3fc4jkjapw8cnh41f09wbbzcfmfmvygrii7z16";

  meta = with lib; {
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva ];
  };
}