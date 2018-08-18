{ fetchurl }:
rec {
  version = "1.8.0";
  src = fetchurl {
    url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-src.tar.bz2";
    sha256 = "63fae6b3a4339e4a40945fae1afb9b99a5e7f8e8dbde668938ab8c4ff569fd7d";
  };

  srcs = [ src
    (fetchurl {
      url = "http://www.openafs.org/dl/openafs/${version}/openafs-${version}-doc.tar.bz2";
      sha256 = "e26f3bb399f524b4978543eb3ec169fd58f2d409cf4bc22c75c65fb9b09f12e8";
    })];
}
