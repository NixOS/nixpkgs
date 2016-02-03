rec {
  stable = {
    wineVersion = "1.8";
    wineSha256  = "1x66lzpk7v8qx57clmcq5ag7yh3mqplf1plypwghgchjh70lafzk";
    ## see http://wiki.winehq.org/Gecko
    geckoVersion = "2.40";
    geckoSha256 = "00nkaxhb9dwvf53ij0q75fb9fh7pf43hmwx6rripcax56msd2a8s";
    gecko64Version = "2.40";
    gecko64Sha256 = "0c4jikfzb4g7fyzp0jcz9fk2rpdl1v8nkif4dxcj28nrwy48kqn3";
    ## see http://wiki.winehq.org/Mono
    monoVersion = "4.5.6";
    monoSha256 = "09dwfccvfdp3walxzp6qvnyxdj2bbyw9wlh6cxw2sx43gxriys5c";
  };
  unstable = {
    wineVersion = "1.9.1";
    wineSha256 = "1dhbp2jy9s3rqsbgc43jz967n2rls8dwdfi96qdxybg8kbxnachb";
    inherit (stable)
      geckoVersion geckoSha256
      gecko64Version gecko64Sha256
      monoVersion monoSha256;
  };
  staging = {
    version = unstable.wineVersion;
    sha256 = "05072wgxy8n6i71bb6649sm0ggh5c4g97clryrr8vkmgsklfkadi";
  };
  winetricks = {
    version = "20160109";
    sha256 = "0pnl5362g5q7py368vj07swbdp1fqbpvpq4jv4l5ddyclps8ajg8";
  };
}
