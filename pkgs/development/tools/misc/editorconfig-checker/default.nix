{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "editorconfig-checker";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "editorconfig-checker";
    repo = "editorconfig-checker";
    rev = version;
    sha256 = "18gz94h2x1z6g6r7v9cdixkbcaigd7cl08af6smlkaa89j0aki32";
  };

  vendorSha256 = "1z4j8vm9mnhjhhmhlj0ycs8b1wpm7lhsfqjnk7w8gfapvj3yfk6h";

  doCheck = false;

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
