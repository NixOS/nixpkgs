{ stdenv, buildGoPackage, fetchFromGitHub, installShellFiles, nixosTests }:

buildGoPackage {
  pname = "mailexporter";
  version = "2019-07-14";

  goPackagePath = "github.com/cherti/mailexporter";

  src = fetchFromGitHub {
    rev = "c60d1970abbedb15e70d6fc858f7fd76fa061ffe";
    owner = "cherti";
    repo = "mailexporter";
    sha256 = "0wlw7jvmhgvg1r2bsifxm2d0vj0iqhplnx6n446625sslvddx3vn";
  };

  goDeps = ./mail-exporter_deps.nix;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage $src/man/mailexporter.1
    installManPage $src/man/mailexporter.conf.5
  '';

  passthru.tests = { inherit (nixosTests.prometheus-exporters) mail; };

  meta = with stdenv.lib; {
    description = "Export Prometheus-style metrics about mail server functionality";
    homepage = "https://github.com/cherti/mailexporter";
    license = licenses.gpl3;
    maintainers = with maintainers; [ willibutz globin ];
    platforms = platforms.linux;
  };
}
