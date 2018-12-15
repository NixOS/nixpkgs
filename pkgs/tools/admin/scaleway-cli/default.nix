{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec{
  name = "scaleway-cli-${version}";
  version = "1.17";

  goPackagePath = "github.com/scaleway/scaleway-cli";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "0v50wk6q8537880whi6w83dia9y934v0s2xr1z52cn3mrsjghsnd";
  };

  meta = with stdenv.lib; {
    description = "Interact with Scaleway API from the command line";
    homepage = https://github.com/scaleway/scaleway-cli;
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
    platforms = platforms.all;
  };
}
