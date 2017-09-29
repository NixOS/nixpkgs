{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "doctl-${version}";
  version = "${major}.${minor}.${patch}";
  major = "1";
  minor = "5";
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
    repo = "doctl";
    rev = "v${version}";
    sha256 = "0dk7l4b0ngqkwdlx8qgr99jzipyzazvkv7dybi75dnp725lwxkl2";
  };

  meta = {
    description = "A command line tool for DigitalOcean services";
    homepage = https://github.com/digitalocean/doctl;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
  };
}
