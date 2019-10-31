{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "chezmoi";
  version = "1.5.5";

  goPackagePath = "github.com/twpayne/chezmoi";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "18kc3b2ncjzxivycx3mhqw9kbqp0sxmlgc2ddvhgj2vpvlkayzkh";
  };

  goDeps = ./deps.nix;

  buildFlagsArray = [
    "-ldflags=-s -w -X ${goPackagePath}/cmd.VersionStr=${version}"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/twpayne/chezmoi;
    description = "Manage your dotfiles across multiple machines, securely";
    license = licenses.mit;
    maintainers = with maintainers; [ jhillyerd ];
    platforms = platforms.all;
  };
}
