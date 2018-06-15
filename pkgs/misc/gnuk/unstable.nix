{ callPackage, fetchgit, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "1.1.4";

  src = fetchgit {
    url = "git://git.gniibe.org/gnuk/gnuk.git";
    rev = "e7e8b9f5ca414a5c901f61b0f043c8da42414103";
    sha256 = "0js9dc1iyvrrcb0d8a2irivrli3yb7mxmpxws5a2n53hj5xc4n6l";
  };
})
