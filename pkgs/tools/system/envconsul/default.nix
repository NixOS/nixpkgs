{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "envconsul-${version}";
  version = "0.6.2";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/envconsul";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "envconsul";
    sha256 = "176jbicyg7vwd0kgawz859gq7ldrxyw1gx55wig7azakiidkl731";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/hashicorp/envconsul/;
    description = "Read and set environmental variables for processes from Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
