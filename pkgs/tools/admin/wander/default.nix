{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "wander";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aQqJDUDYHoUZ6ixnY3lmFOx29QpRRke5XHFIpsA+Bnw=";
  };

  vendorSha256 = "sha256-T+URnRLumXFz48go9TN0Wha99T03OWGfDK7cQ+zKeRI=";

  meta = with lib; {
    description = "Terminal app/TUI for HashiCorp Nomad";
    license = licenses.mit;
    homepage = "https://github.com/robinovitch61/wander";
    maintainers = teams.c3d2.members;
  };
}
