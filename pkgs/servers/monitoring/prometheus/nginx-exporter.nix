{ stdenv, lib, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "nginx_exporter-${version}";
  version = "20161104-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "1b2a3d124b6446a0159a68427b0dc3a8b9f32203";

  goPackagePath = "github.com/discordianfish/nginx_exporter";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/discordianfish/nginx_exporter";
    sha256 = "19nmkn81m0nyq022bnmjr93wifig4mjcgvns7cbn31i197cydw28";
  };

  goDeps = ./nginx-exporter_deps.nix;

  meta = with stdenv.lib; {
    description = "Metrics relay from nginx stats to Prometheus";
    homepage = https://github.com/discordianfish/nginx_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
