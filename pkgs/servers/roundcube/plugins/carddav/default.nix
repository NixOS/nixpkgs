{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "carddav";
  version = "4.4.6";

  src = fetchzip {
    url = "https://github.com/mstilkerich/rcmcarddav/releases/download/v${version}/carddav-v${version}.tar.gz";
    sha256 = "10s4idf5kmkap47fn3i4jkr3mbipibdjcqds8p6p906nr45ngs57";
  };
}
