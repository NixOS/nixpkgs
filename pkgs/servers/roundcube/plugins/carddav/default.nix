{ roundcubePlugin, fetchzip }:

roundcubePlugin rec {
  pname = "carddav";
  version = "5.1.3";

  src = fetchzip {
    url = "https://github.com/mstilkerich/rcmcarddav/releases/download/v${version}/carddav-v${version}.tar.gz";
    sha256 = "sha256-INWMFNVs+hDJb0tYjmM3x6JtXpR6WAwPn2ZuVuDzjXo=";
  };
}
