{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "matterircd-${version}";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "1fgpfyb78l1kl0kja2fjqc4ik1q869cmhx6xdmp9ff2qcqk22cj0";
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
