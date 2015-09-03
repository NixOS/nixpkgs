{ lib, fetchFromGitHub, goPackages }:

with goPackages;

buildGoPackage rec {
  rev = "0.3.0";
  name = "bosun-${rev}";
  goPackagePath = "bosun.org";
  src = fetchFromGitHub {
    inherit rev;
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "05qfhm5ipdry0figa0rhmg93c45dzh2lwpia73pfxp64l1daqa3a";
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
