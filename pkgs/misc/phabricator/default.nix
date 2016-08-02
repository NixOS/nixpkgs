{ stdenv, fetchgit, pkgs, ...  }:

stdenv.mkDerivation rec {
  version = "2014-07-16";
  name = "phabricator-${version}";
  srcLibphutil = pkgs.fetchgit {
      url = git://github.com/facebook/libphutil.git;
      rev = "48a04395363d6c1dd9f66057bd11fd70d4665ba9";
      sha256 = "198w4kq86py31m86sgpinz2va3m9j8k92q2pa2qzzi0lyf1sb8c3";
  };
  srcArcanist = pkgs.fetchgit {
      url = git://github.com/facebook/arcanist.git;
      rev = "97501da16416fbfdc6e84bd60abcbf5ad9506225";
      sha256 = "1afn25db4pv3amjh06p8jk3s14i5139n59zk3h4awk84d2nj1kzk";
  };
  srcPhabricator = pkgs.fetchgit {
      url = git://github.com/phacility/phabricator.git;
      rev = "7ac5abb97934f7399b67762aa98f59f667711bf3";
      sha256 = "1hk6fnvdfn5w82wnprjdkjm8akzw3zfqm460cjqd8v3q5n21ddpf";
  };

  buildCommand = ''
    mkdir -p $out
    cp -R ${srcLibphutil} $out/libphutil
    cp -R ${srcArcanist} $out/arcanist
    cp -R ${srcPhabricator} $out/phabricator
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
