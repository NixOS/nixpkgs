{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-04-22";

  src = fetchgit {
    url = "git://git.gniibe.org/gnuk/gnuk.git";
    rev = "3d5a776ab15a4ae6e17d91341a58eda3db09f700";
    sha256 = "1pkdca331wrf1lsnlxxwbbnfcr7vj9xsac92dhj06fhpq4mb8kgb";
  };
})
