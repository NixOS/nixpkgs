{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "wo-istes-jetzt-${version}";
  version = "2016-07-29";
  rev = "41b42ed59eb820e071ef8542a78c4f41752c1ac0";

  goPackagePath = "github.com/elseym/wo.istes.jetzt";

  prePatch = ''
    substituteInPlace main.go --replace './offset_map.json' "$bin/share//wo.istes.jetzt/offset_map.json"
  '';

  postInstall = ''
    mkdir -p $bin/share/wo.istes.jetzt
    cp $src/offset_map.json $bin/share/wo.istes.jetzt
  '';

  src = fetchFromGitHub {
    inherit rev;
    owner = "elseym";
    repo = "wo.istes.jetzt";
    sha256 = "1vfmyzmdqk01bbd7yp64rhkilz5jkrv8wqyrxx1b0mlgyys0byrf";
  };
}
