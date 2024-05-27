{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "MailHog";
  version = "1.0.1";

  goPackagePath = "github.com/mailhog/MailHog";

  src = fetchFromGitHub {
    owner = "mailhog";
    repo = "MailHog";
    rev = "v${version}";
    sha256 = "124216850572r1h0ii7ad6jd1cd5czcvkz7k2jzvjb4pv2kl8p3y";
  };

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Web and API based SMTP testing";
    mainProgram = "MailHog";
    homepage = "https://github.com/mailhog/MailHog";
    changelog = "https://github.com/mailhog/MailHog/releases/tag/v${version}";
    maintainers = with maintainers; [ disassembler jojosch ];
    license = licenses.mit;
  };
}
