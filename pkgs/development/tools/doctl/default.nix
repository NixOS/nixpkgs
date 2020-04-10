{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "doctl";
  version = "1.40.0";

  goPackagePath = "github.com/digitalocean/doctl";

  subPackages = [ "cmd/doctl" ];

  buildFlagsArray = ''
    -ldflags=
    -X ${goPackagePath}.Major=${lib.versions.major version}
    -X ${goPackagePath}.Minor=${lib.versions.minor version}
    -X ${goPackagePath}.Patch=${lib.versions.patch version}
    -X ${goPackagePath}.Label=release
  '';

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo = "doctl";
    rev = "v${version}";
    sha256 = "1x8rr3707mmbfnjn3ck0953xkkrfq5r8zflbxpkqlfz9k978z835";
  };

  meta = with lib; {
    description = "A command line tool for DigitalOcean services";
    homepage = "https://github.com/digitalocean/doctl";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = [ maintainers.siddharthist ];
  };
}
