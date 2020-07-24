{lib, fetchFromGitHub, buildGoModule }:

buildGoModule {
  pname = "matrix-corporal";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "devture";
    repo = "matrix-corporal";
    rev = "1.9.0";
    sha256 = "0zwfvlhp9j3skz6ryi01d7ps3wm8kb3njcbjf0bl1gv2h0cjhlji";
  };

  vendorSha256 = "1fghbl0b418ld5szjafbiz3vp773skc0l6kaif5c2vsh2ivgr6hl";

  meta = with lib; {
    homepage = "https://github.com/devture/matrix-corporal";
    description = "Reconciliator and gateway for a managed Matrix server";
    maintainers = [ teams.matrix.members ];
    license = licenses.agpl3;
  };
}
