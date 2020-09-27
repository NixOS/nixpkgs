{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule {
  pname = "smtp-to-telegram";
  version = "unstable-2022-11-06";
  rev = "2f1167e45450151ec09f420ae6deb4a101ed1d30";

  src = fetchFromGitHub {
    owner = "KostyaEsmukov";
    repo = "smtp_to_telegram";
    rev = "2f1167e45450151ec09f420ae6deb4a101ed1d30";
    hash = "sha256-7erh+Bpl4il5auQXg+00W1rjkxbuEKlkczHVKCfdkdg=";
  };

  vendorSha256 = "sha256-o1huUGDPJMJruA11ny8aAKZHkXg1ksqhzTaBeXpOFGA=";

  meta = {
    description = "SMTP server that forwards messages to Telegram";
    homepage = "https://github.com/KostyaEsmukov/smtp_to_telegram";
    maintainers = with lib.maintainers; [ patryk27 ];
    license = lib.licenses.mit;
  };
}
