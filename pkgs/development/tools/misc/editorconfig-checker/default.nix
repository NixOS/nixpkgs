{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = "${version}";
    sha256 = "09v8gqwcaay3bqbidparmg20dy0mvlrzh34591hanbrx3cwhrz3f";
  };

  vendorSha256 = "132blcdw3lywxhqslkcpwwvkzl4cpbbkhb7ba8mrvfgl5kvfm1q0";

  nativeBuildInputs = [ installShellFiles ];

  buildFlagsArray = [ "-ldflags=-X main.version=${version}" ];

  postInstall = ''
    installManPage docs/editorconfig-checker.1
  '';

  meta = with lib; {
    description = "A tool to verify that your files are in harmony with your .editorconfig";
    homepage = "https://editorconfig-checker.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ uri-canva zowoq ];
  };
}
