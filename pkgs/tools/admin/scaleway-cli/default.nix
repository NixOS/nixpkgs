{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec{
  name = "scaleway-cli-${version}";
  version = "1.14";

  goPackagePath = "github.com/scaleway/scaleway-cli";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "09rqw82clfdiixa9m3hphxh5v7w1gks3wicz1dvpay2sx28bpddr";
  };

  meta = with stdenv.lib; {
    description = "Interact with Scaleway API from the command line";
    homepage = https://github.com/scaleway/scaleway-cli;
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu ];
    platforms = platforms.all;
  };
}
