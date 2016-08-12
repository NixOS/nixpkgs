{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "0.9";
  rev = "f28af637327a4f12ae745284c519cfdeca5502ef";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    inherit rev;
    owner = "mholt";
    repo = "caddy";
    sha256 = "1s7z0xbcw516i37pyj1wgxd9diqrifdghf97vs31ilbqs6z0nyls";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/mholt/caddy/caddy/caddymain.gitTag=${version}
  '';

  goDeps = ./deps.json;
}
