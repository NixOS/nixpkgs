{ lib, buildGoModule, fetchFromGitHub, installShellFiles, nixosTests }:

buildGoModule {
  pname = "mailexporter";
  version = "2020-07-16";

  src = fetchFromGitHub {
    owner = "cherti";
    repo = "mailexporter";
    rev = "f5a552c736ac40ccdc0110d2e9a71619c1cd6862";
    hash = "sha256-P7LZi2iXZJaY5AEJBeAVszq/DN9SFxNfeQaflnF6+ng=";
  };

  vendorHash = "sha256-QOOf00uCdC8fl7V/+Q8X90yQ7xc0Tb6M9dXisdGEisM=";

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
