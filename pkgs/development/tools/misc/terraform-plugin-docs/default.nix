{ lib, buildGoModule, fetchFromGitHub, makeWrapper, musl, terraform, go, testers, terraform-plugin-docs }:

buildGoModule rec {
  pname = "terraform-plugin-docs";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-plugin-docs";
    rev = "v${version}";
    hash = "sha256-5vbi69GMgkzvN3aEQbNTbk99rg+kfvAvUrdDsuyIm9s=";
  };

  subPackages = [ "cmd/tfplugindocs" ];
  vendorHash = "sha256-AjW6BokLVDkIWXToJ7wNq/g19xKTAfpQ/gVlKCV5qw0=";
  allowGoReference = true;
  nativeBuildInputs = [ musl makeWrapper ];
  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
    "-linkmode external"
    "-extldflags '-static -L${musl}/lib'"
  ];

  postInstall = ''
    wrapProgram $out/bin/tfplugindocs --prefix PATH : ${lib.makeBinPath [ terraform go ]}
  '';

  passthru.tests.version = testers.testVersion {
    command = "tfplugindocs --version";
    package = terraform-plugin-docs;
  };

  meta = with lib; {
    homepage = "https://github.com/hashicorp/terraform-plugin-docs";
    changelog = "https://github.com/hashicorp/terraform-plugin-docs/releases/tag/v${version}";
    description = "Generate and validate Terraform plugin/provider documentation.";
    mainProgram = "tfplugindocs";
    maintainers = with maintainers; [ catouc ];
    platforms = platforms.linux;
    license = licenses.mpl20;
  };
}
