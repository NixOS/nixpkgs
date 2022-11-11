{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "carddav";
  version = "4.4.4";

  src = fetchzip {
    url = "https://github.com/mstilkerich/rcmcarddav/releases/download/v${version}/carddav-v${version}.tar.gz";
    sha256 = "1l35z2k43q8cflhzmk43kifrskhcvygrsvbbzs2s8hhjhsz2b3aq";
  };
}
