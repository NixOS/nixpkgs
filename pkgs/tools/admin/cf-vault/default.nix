{buildGoModule, fetchFromGitHub, lib}:
buildGoModule rec {
  pname = "cf-vault";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "jacobbednarz";
    repo = pname;
    rev = version;
    sha256 = "sha256-puuP7L8KJ3MvlWz5tOeov8HZad+Lvo64DqTbaKPfg6o=";
  };

  vendorHash = "sha256-cnv3vustgougdfU9RlyP4O3e7kx9nNzzJm1Q2d+sCDo=";

  meta = with lib; {
    description = ''
      A tool for managing your Cloudflare credentials, securely..
    '';
    homepage = "https://github.com/jacobbednarz/cf-vault/";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}
