{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "matterircd-${version}";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "42wim";
    repo = "matterircd";
    rev = "v${version}";
    sha256 = "0yxqlckir50kdlbi36kak5ncfzl6sh811hzicdar5yzanzcip8ja";
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
