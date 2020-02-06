{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "doctl";
  version = "${major}.${minor}.${patch}";
  major = "1";
  minor = "35";
  patch = "0";
  goPackagePath = "github.com/digitalocean/doctl";

  excludedPackages = ''\(doctl-gen-doc\|install-doctl\|release-doctl\)'';
  buildFlagsArray = let t = goPackagePath; in ''
     -ldflags=
        -X ${t}.Major=${major}
        -X ${t}.Minor=${minor}
        -X ${t}.Patch=${patch}
        -X ${t}.Label=release
   '';

  src = fetchFromGitHub {
    owner  = "digitalocean";
    repo   = "doctl";
    rev    = "v${version}";
    sha256 = "1blg4xd01vvr8smpii60jlk7rg1cg64115azixw9q022f7cnfiyw";
  };

  meta = {
    description = "A command line tool for DigitalOcean services";
    homepage = https://github.com/digitalocean/doctl;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
  };
}
