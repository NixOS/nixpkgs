{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "chezmoi-${version}";
  version = "1.3.0";

  goPackagePath = "github.com/twpayne/chezmoi";

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
    sha256 = "0dvdjx5khpw62lprn06k271xfc9fdrw4c1q74vd1vffaz60yfd8d";
  };

  goDeps = ./deps.nix;

  buildFlagsArray = [
    "-ldflags=-s -w -X ${goPackagePath}/cmd.version=${version}"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/twpayne/chezmoi;
    description = "Manage your dotfiles across multiple machines, securely";
    license = licenses.mit;
    maintainers = with maintainers; [ jhillyerd ];
    platforms = platforms.all;
  };
}
