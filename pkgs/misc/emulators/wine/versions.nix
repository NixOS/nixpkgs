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
    wineVersion = "1.8-rc4"; ## wait for staging 1.8
    wineSha256  = "0c4mb49ad11jd880wdl4gs1478q2rkdjw2qxjzskr08bdlcq7h5f";
    inherit (stable)
      geckoVersion geckoSha256
      gecko64Version gecko64Sha256
      monoVersion monoSha256;
  };
  staging = {
    version = unstable.wineVersion;
    sha256 = "11kd4id0zyqqjz1006d27ahmhy3gzai7h0wir9lkxnv3pdld0dxn";
  };
  winetricks = {
    version = "20151116";
    sha256 = "1iih2b85s7f4if1mn36infc43hd4pdp8bl84q0nml3gh3fh8zqpr";
  };
}
