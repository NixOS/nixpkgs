{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "wander";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z3jvKBhzlATTh6zPoJoMmg/DAE5/Ur3Tb3sdgGPEm6k=";
  };

  vendorSha256 = "sha256-gWQ8GbtghhCRq6tOU6qmWBuponmfUkUDAk3+dPtmMiE=";

  meta = with lib; {
    description = "Terminal app/TUI for HashiCorp Nomad";
    license = licenses.mit;
    homepage = "https://github.com/robinovitch61/wander";
    maintainers = teams.c3d2.members;
  };
}
