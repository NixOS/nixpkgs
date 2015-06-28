{ lib, fetchFromGitHub, goPackages }:

with goPackages;

buildGoPackage rec {
  rev = "20150506172827";
  name = "scollector-${rev}";
  goPackagePath = "bosun.org";
  src = fetchFromGitHub {
    inherit rev;
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "0rnfiv9b835b8j8r9qh9j2mz9mm9q45vfg9cqa4nngrgfd0cqvl8";
  };
  subPackages = [ "cmd/scollector" ];

  meta = with lib; {
    description = "Collect system information and store it in OpenTSDB or Bosun";
    homepage = http://bosun.org/scollector;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
