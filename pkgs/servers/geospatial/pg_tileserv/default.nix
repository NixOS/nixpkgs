{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "pg_tileserv";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "CrunchyData";
    repo = "pg_tileserv";
    rev = "v${version}";
    hash = "sha256-xTIx39eLmHBUlaUjQy9KGpi5X4AU93DzX+Ofg5PMLWE=";
  };

  vendorHash = "sha256-8CvYvoIKOYvR7npCV65ZqZGR8KCTH4GabTt/JGQG3uc=";

  postPatch = ''
    # fix default configuration file location
    substituteInPlace \
      main.go \
      --replace-fail "viper.AddConfigPath(\"/etc\")" "viper.AddConfigPath(\"$out/share/config\")"

    # fix assets location in configuration file
    substituteInPlace \
      config/pg_tileserv.toml.example \
      --replace-fail "# AssetsPath = \"/usr/share/pg_tileserv/assets\"" "AssetsPath = \"$out/share/assets\""
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.programVersion=${version}"
  ];

  postInstall = ''
    mkdir -p $out/share
    cp -r assets $out/share

    mkdir -p $out/share/config
    cp config/pg_tileserv.toml.example $out/share/config/pg_tileserv.toml
  '';

  doCheck = false;

  meta = with lib; {
    description = "A very thin PostGIS-only tile server in Go";
    mainProgram = "pg_tileserv";
    homepage = "https://github.com/CrunchyData/pg_tileserv";
    license = licenses.asl20;
    maintainers = teams.geospatial.members;
  };
}
