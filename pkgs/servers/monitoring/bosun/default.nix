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
  subPackages = [ "cmd/bosun" ];

  meta = with lib; {
    description = "Time series alerting framework";
    longDescription = ''
      An advanced, open-source monitoring and alerting system by Stack Exchange.
    '';
    homepage = http://bosun.org;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
