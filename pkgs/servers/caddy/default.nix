{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "caddy-${version}";
  version = "v0.9.1";

  goPackagePath = "github.com/mholt/caddy";

  subPackages = [ "caddy" ];

  src = fetchFromGitHub {
    owner = "mholt";
    repo = "caddy";
    rev = version;
    sha256 = "0slh4nf5pd42mgj1j9hzywqpc3p6d211dm6pdlhb6lyn8f6nprgp";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/mholt/caddy/caddy/caddymain.gitTag=${version}
  '';

  goDeps = ./deps.json;
}
