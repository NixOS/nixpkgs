{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "subfinder-git-${version}";
  version = "2018-07-15";

  goPackagePath = "github.com/subfinder/subfinder";

  src = fetchFromGitHub {
    owner = "subfinder";
    repo = "subfinder";
    rev = "26596affed961c535676395f443acc5af95ac9e6";
    sha256 = "0m842jyrwlg4kaja1m3kca07jf20fxva0frg66b13zpsm8hdp10q";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Subdomain discovery tool";
    longDescription = ''
      SubFinder is a subdomain discovery tool that discovers valid
      subdomains for websites. Designed as a passive framework to be
      useful for bug bounties and safe for penetration testing.
    '';
    homepage = https://github.com/subfinder/subfinder;
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
  };
}
