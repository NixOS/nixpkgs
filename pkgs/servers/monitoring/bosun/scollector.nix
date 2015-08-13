{ lib, fetchFromGitHub, goPackages }:

with goPackages;

buildGoPackage rec {
  rev = "0.3.0";
  name = "scollector-${rev}";
  goPackagePath = "bosun.org";
  src = fetchFromGitHub {
    inherit rev;
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "05qfhm5ipdry0figa0rhmg93c45dzh2lwpia73pfxp64l1daqa3a";
  };
  subPackages = [ "cmd/scollector" ];

  meta = with lib; {
    description = "Collect system information and store it in OpenTSDB or Bosun";
    homepage = http://bosun.org/scollector;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
