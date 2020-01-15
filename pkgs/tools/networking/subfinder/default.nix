{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "subfinder";
  version = "2.3.0";

  goPackagePath = "github.com/projectdiscovery/subfinder";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vjxi2h4njakyqkfzwwaacy37kqx66j2y3k5l752z9va73gv7xv1";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Subdomain discovery tool";
    longDescription = ''
      SubFinder is a subdomain discovery tool that discovers valid
      subdomains for websites. Designed as a passive framework to be
      useful for bug bounties and safe for penetration testing.
    '';
    homepage = "https://github.com/projectdiscovery/subfinder";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz filalex77 ];
  };
}
