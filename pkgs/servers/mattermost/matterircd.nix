{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "matterircd-${version}";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "10fmn6midfzmn6ylhrk00bvykn0zijypiqp5hjqn642kcdkrjc6i";
  };

  goPackagePath = "github.com/42vim/matterircd";

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Minimal IRC server bridge to Mattermost";
    license = licenses.mit;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.unix;
  };
}
