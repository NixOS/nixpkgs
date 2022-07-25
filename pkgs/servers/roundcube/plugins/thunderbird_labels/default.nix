{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "thunderbird_labels";
  version = "1.4.11";

  src = fetchzip {
    url = "https://github.com/mike-kfed/roundcube-thunderbird_labels/archive/refs/tags/v${version}.tar.gz";
    sha256 = "1agnj4lsy6bcqvxyrf2vv63fsxhr6sjn5z8qkkb8yp8fjmmn4fbx";
  };
}
