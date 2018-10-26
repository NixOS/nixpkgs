{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

with stdenv.lib;

buildGoPackage rec {
  name = "kubicorn-${version}";
  version = "2018-10-13-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "4c7f3623e9188fba43778271afe161a4facfb657";

  src = fetchFromGitHub {
    rev = rev;
    owner = "kubicorn";
    repo = "kubicorn";
    sha256 = "18h5sj4lcivrwjq2hzn7c3g4mblw17zicb5nma8sh7sakwzyg1k9";
  };

  subPackages = ["."];
  goPackagePath = "github.com/kubicorn/kubicorn";

  meta = {
    description = "Simple, cloud native infrastructure for Kubernetes";
    homepage = http://kubicorn.io/;
    maintainers = with stdenv.lib.maintainers; [ offline ];
    license = stdenv.lib.licenses.asl20;
  };
}
