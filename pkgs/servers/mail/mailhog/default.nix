{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "MailHog";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mailhog";
    repo = "MailHog";
    rev = "v${version}";
    hash = "sha256-flxEp9iXLLm/FPP8udlnpbHQpGnqxAhgyOIUUJAJgog=";
  };

  postPatch = ''
    go mod init github.com/mailhog/MailHog
  '';

  vendorHash = null;

  ldflags = [ "-s" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Web and API based SMTP testing";
    mainProgram = "MailHog";
    homepage = "https://github.com/mailhog/MailHog";
    changelog = "https://github.com/mailhog/MailHog/releases/tag/v${version}";
    maintainers = with maintainers; [ disassembler jojosch ];
    license = licenses.mit;
  };
}
