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

  modSha256 = "1iiv12ginb3ky739z7v8wf4z5lv24gmghbybs3lzay0kqn449n4x";

  meta = with lib; {
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva ];
  };
}
