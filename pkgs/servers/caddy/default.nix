{ stdenv, buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "v0.9.0";
  rev = "f28af637327a4f12ae745284c519cfdeca5502ef";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/mholt/caddy.git";
    sha256 = "1s7z0xbcw516i37pyj1wgxd9diqrifdghf97vs31ilbqs6z0nyls";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/mholt/caddy/caddy/caddymain.gitTag=${version}
  '';

  goDeps = ./deps.json;
}
