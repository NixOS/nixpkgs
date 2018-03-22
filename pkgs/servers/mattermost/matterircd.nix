{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "matterircd-${version}";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "1rsmc2dpf25rkl8c085xwssbry3hv1gv318m7rdj616agx4m7yr2";
  };

  goPackagePath = "github.com/42wim/matterircd";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Minimal IRC server bridge to Mattermost";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
