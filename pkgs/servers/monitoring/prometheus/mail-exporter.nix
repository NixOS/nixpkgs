{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests }:

buildGoModule {
  pname = "mailexporter";
  version = "2020-07-16";

  src = fetchFromGitHub {
    owner = "cherti";
    repo = "mailexporter";
    rev = "f5a552c736ac40ccdc0110d2e9a71619c1cd6862";
    sha256 = "0y7sg9qrd7q6g5gi65sjvw6byfmk2ph0a281wjc9cr4pd25xkciz";
  };

  vendorSha256 = "1hwahk8v3qnmyn6bwk9l2zpr0k7p2w7zjzxmjwgjyx429g9rzqs0";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage $src/man/mailexporter.1
    installManPage $src/man/mailexporter.conf.5
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) mail; };

  meta = with lib; {
    description = "Export Prometheus-style metrics about mail server functionality";
    homepage = "https://github.com/cherti/mailexporter";
    license = licenses.gpl3;
    maintainers = with maintainers; [ willibutz globin ];
    platforms = platforms.linux;
  };
}
