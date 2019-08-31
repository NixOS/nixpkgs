{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "doctl";
  version = "${major}.${minor}.${patch}";
  major = "1";
  minor = "18";
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
    sha256 = "1p43q1iyjj597gr47hn589fv7n26mny9niq7yb9hlmslkplsrb0a";
  };

  meta = {
    description = "A command line tool for DigitalOcean services";
    homepage = https://github.com/digitalocean/doctl;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
  };
}
