{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "matterircd";
  version = "0.19.4";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "1kwyk6gy4d4v2rzyr7vwvi8vm69rz1hdn0gkpan2kh1p63z77gbv";
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
