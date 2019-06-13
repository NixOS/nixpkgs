{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "nginx_exporter-${version}";
  version = "0.1.0";

  goPackagePath = "github.com/discordianfish/nginx_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "discordianfish";
    repo = "nginx_exporter";
    sha256 = "1xwxnvkzslaj44r44ag24a9qfzjdxwz67hhpkdq42193zqpnlim7";
  };

  goDeps = ./nginx-exporter_deps.nix;

  meta = with stdenv.lib; {
    description = "Metrics relay from nginx stats to Prometheus";
    homepage = https://github.com/discordianfish/nginx_exporter;
    license = licenses.mit;
    maintainers = with maintainers; [ benley fpletz willibutz ];
    platforms = platforms.unix;
  };
}
