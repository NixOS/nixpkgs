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
  subPackages = [ "cmd/scollector" ];

  meta = with lib; {
    description = "Collect system information and store it in OpenTSDB or Bosun";
    homepage = http://bosun.org/scollector;
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
