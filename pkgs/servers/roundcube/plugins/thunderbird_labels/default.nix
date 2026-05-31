{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "thunderbird_labels";
  version = "1.6.0";

  src = fetchzip {
    url = "https://github.com/mike-kfed/roundcube-thunderbird_labels/archive/refs/tags/v${version}.tar.gz";
    sha256 = "09hh3d0n12b8ywkazh8kj3xgn128k35hyjhpa98c883b6b9y8kif";
  };
}
