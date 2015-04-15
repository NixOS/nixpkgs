{ lib, fetchFromGitHub, goPackages }:

with goPackages;

buildGoPackage rec {
  rev = "20150409220449";
  name = "bosun-${rev}";
  goPackagePath = "bosun.org";
  src = fetchFromGitHub {
    inherit rev;
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "02bvq9hx2h4pgjclv09nm0al8ybvq0syhyhn5cvw0wgnn9bwn5mb";
  };
  subPackages = [ "cmd/scollector" ];

  meta = with lib; {
    description = "Collect system information and store it in OpenTSDB or Bosun";
    homepage = http://bosun.org/scollector;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
