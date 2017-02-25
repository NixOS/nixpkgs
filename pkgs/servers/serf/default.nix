{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "serf-${version}";
  version = "0.8.1";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/serf";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "serf";
    inherit rev;
    sha256 = "1arakjvhyasrk52vhxas2ghlrby3i3wj59r7sjrkbpln2cdbqnlx";
  };

  meta = with stdenv.lib; {
    description = "Tool for service orchestration and management";
    homepage = "https://www.serf.io/";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ pradeepchhetri ];
  };
}
