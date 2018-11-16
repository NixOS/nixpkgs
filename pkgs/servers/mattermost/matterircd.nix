{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "matterircd-${version}";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "0g57g91v7208yynf758k9v73jdhz4fbc1v23p97rzrl97aq0rd5r";
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
