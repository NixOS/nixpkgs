{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "doctl-${version}";
  version = "${major}.${minor}.${patch}";
  major = "1";
  minor = "8";
  patch = "0";
  goPackagePath = "github.com/digitalocean/doctl";

  excludedPackages = ''\(doctl-gen-doc\|install-doctl\|release-doctl\)'';
  buildFlagsArray = let t = "${goPackagePath}"; in ''
     -ldflags=
        -X ${t}.Major=${major}
        -X ${t}.Minor=${minor}
        -X ${t}.Patch=${patch}
        -X ${t}.Label=release
   '';

  src = fetchFromGitHub {
    owner = "digitalocean";
    repo   = "doctl";
    rev    = "v${version}";
    sha256 = "1h94qagbni8cvzdparmgx3m9qcnbwbk0kjlvy9jzxfd3vcpbg38j";
  };

  meta = {
    description = "A command line tool for DigitalOcean services";
    homepage = https://github.com/digitalocean/doctl;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
  };
}
