{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "prom2json-${version}";
  version = "0.1.0";
  rev = "${version}";

  goPackagePath = "github.com/prometheus/prom2json";

  src = fetchFromGitHub {
    inherit rev;
    owner = "prometheus";
    repo = "prom2json";
    sha256 = "0wwh3mz7z81fwh8n78sshvj46akcgjhxapjgfic5afc4nv926zdl";
  };

  goDeps = ./prom2json_deps.json;

  meta = with stdenv.lib; {
    description = "Tool to scrape a Prometheus client and dump the result as JSON";
    homepage = https://github.com/prometheus/prom2json;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
