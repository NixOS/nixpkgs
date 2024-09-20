{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "pg_featureserv";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GsloUZFgrOrJc23vKv+8iSeyIEKblaukPSCpZGRtSL4=";
  };

  vendorHash = "sha256-BHiEVyi3FXPovYy3iDP8q+y+LgfI4ElDPVZexd7nnuo=";

  postPatch = ''
    # fix default configuration file location
    substituteInPlace \
      internal/conf/config.go \
      --replace-fail "viper.AddConfigPath(\"/etc\")" "viper.AddConfigPath(\"$out/share/config\")"

    # fix assets location in configuration file
    substituteInPlace \
      config/pg_featureserv.toml.example \
      --replace-fail "AssetsPath = \"./assets\"" "AssetsPath = \"$out/share/assets\""
  '';

  ldflags = [ "-s" "-w" "-X github.com/CrunchyData/pg_featureserv/conf.setVersion=${version}" ];

  postInstall = ''
    mkdir -p $out/share
    cp -r assets $out/share

    mkdir -p $out/share/config
    cp config/pg_featureserv.toml.example $out/share/config/pg_featureserv.toml
  '';

  meta = with lib; {
    description = "Lightweight RESTful Geospatial Feature Server for PostGIS in Go";
    mainProgram = "pg_featureserv";
    homepage = "https://github.com/CrunchyData/pg_featureserv";
    license = licenses.asl20;
    maintainers = teams.geospatial.members;
  };
}
