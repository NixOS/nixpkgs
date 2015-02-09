{ lib, fetchFromGitHub, goPackages }:

with goPackages;

buildGoPackage rec {
  rev = "20150202222550";
  name = "bosun-${rev}";
  goPackagePath = "bosun.org";
  src = fetchFromGitHub {
    inherit rev;
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "0xrnyq85nxj6rddrhd19r2bz59pzxci6bnjh61j4z8hd6ryp8j2c";
  };
  subPackages = [ "cmd/scollector" ];

  meta = with lib; {
    description = "Collect system information and store it in OpenTSDB or Bosun";
    homepage = http://bosun.org/scollector;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
