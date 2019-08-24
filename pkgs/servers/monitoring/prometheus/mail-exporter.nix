{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
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

  postInstall = ''
    install -D -m 0444 -t $bin/share/man/man1 $src/man/mailexporter.1
    install -D -m 0444 -t $bin/share/man/man5 $src/man/mailexporter.conf.5
  '';

  meta = with stdenv.lib; {
    description = "Export Prometheus-style metrics about mail server functionality";
    homepage = "https://github.com/cherti/mailexporter";
    license = licenses.gpl3;
    maintainers = with maintainers; [ willibutz globin ];
    platforms = platforms.linux;
  };
}
