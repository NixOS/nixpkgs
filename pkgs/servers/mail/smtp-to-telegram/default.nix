{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "smtp-to-telegram";
  version = "unstable-2020-05-09";
  rev = "8092fc365b902d160d3e3de6ceb7ca67a17392d0";

  src = fetchFromGitHub {
    inherit rev;
    owner = "KostyaEsmukov";
    repo = "smtp_to_telegram";
    hash = "sha256-cCIK2IOCcnaRwsqDZbZk7Ov09IlfCkR1eolNSXS/nRw=";
  };

  vendorSha256 = "sha256-q7v2IQqWHap4JSmRcXjSI6aWb3kF/tA1dk5NXWBeytE=";

  meta = {
    description = "SMTP server that forwards messages to Telegram";
    homepage = "https://github.com/KostyaEsmukov/smtp_to_telegram";
    maintainers = with lib.maintainers; [ patryk27 ];
    license = lib.licenses.mit;
  };
}
