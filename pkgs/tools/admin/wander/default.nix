{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "wander";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "robinovitch61";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B+mMC5XGUTNTcxwKhvSSc7QbsLkg8qu7/jJf5U/q6s8=";
  };

  vendorSha256 = "sha256-gWQ8GbtghhCRq6tOU6qmWBuponmfUkUDAk3+dPtmMiE=";

  meta = with lib; {
    description = "Terminal app/TUI for HashiCorp Nomad";
    license = licenses.mit;
    homepage = "https://github.com/robinovitch61/wander";
    maintainers = teams.c3d2.members;
  };
}
