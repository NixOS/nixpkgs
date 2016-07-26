{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "wo-istes-jetzt-${version}";
  version = "2016-07-24";
  rev = "b6af2a7d19f974c6d945b6d97b4019f21e793835";

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
    sha256 = "0n3gzpgryyv5qyxqxh6dibp572am33kx0sb9wkwzi5riydfy6nch";
  };
}
