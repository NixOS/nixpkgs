{ lib, fetchFromGitHub, goPackages }:

with goPackages;

buildGoPackage rec {
  rev = "20150311224711";
  name = "bosun-${rev}";
  goPackagePath = "bosun.org";
  src = fetchFromGitHub {
    inherit rev;
    owner = "bosun-monitor";
    repo = "bosun";
    sha256 = "1nzzmlbiah7lpkm5n7yzxv1wmcxg8pszlzzsdvb7ccy0agpihxjg";
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
