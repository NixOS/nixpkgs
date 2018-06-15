{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "envconsul-${version}";
  version = "0.7.3";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/envconsul";

  src = fetchFromGitHub {
    inherit rev;
    owner = "hashicorp";
    repo = "envconsul";
    sha256 = "03cgxkyyynr067dg5b0lhvaxn60318fj9fh55p1n43vj5nrzgnbc";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/hashicorp/envconsul/;
    description = "Read and set environmental variables for processes from Consul";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
