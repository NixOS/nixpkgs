{
  unstable = {
    wineVersion = "1.7.43";
    wineSha256  = "08kqj02m8xc1ppzhs5y83zzykjnz0qliq495rx1n90ybzyd9pm2k";
    geckoVersion = "2.36";
    geckoSha256 = "12hjks32yz9jq4w3xhk3y1dy2g3iakqxd7aldrdj51cqiz75g95g";
    gecko64Version = "2.36";
    gecko64Sha256 = "0i7dchrzsda4nqbkhp3rrchk74rc2whn2af1wzda517m9c0886vh";
    monoVersion = "4.5.6";
    monoSha256 = "09dwfccvfdp3walxzp6qvnyxdj2bbyw9wlh6cxw2sx43gxriys5c";
  };
  stable = {
    wineVersion = "1.6.2";
    wineSha256  = "1gmc0ljgfz3qy50mdxcwwjcr2yrpz54jcs2hdszsrk50wpnrxazh";
    geckoVersion = "2.21";
    geckoSha256 = "1n0zccnvchkg0m896sjx5psk4bxw9if32xyxib1rbfdasykay7zh";
    gecko64Version = "2.21";
    gecko64Sha256 = "0grc86dkq90i59zw43hakh62ra1ajnk11m64667xjrlzi7f0ndxw";
    monoVersion = "4.5.6";
    monoSha256 = "09dwfccvfdp3walxzp6qvnyxdj2bbyw9wlh6cxw2sx43gxriys5c";
    ## TESTME wine stable should work with most recent mono
    #monoVersion = "0.0.8";
    #monoSha256 = "00jl24qp7vh3hlqv7wsw1s529lr5p0ybif6s73jy85chqaxj7z1x";
  };
  staging = {
    version = "1.7.43";
    sha256 = "01b7npa8hc2nrv4hm16r9ikic4wd34nbz1lvfhy0ali2jbcsaqqb";
  };
  winetricks = {
    version = "20150416";
    sha256 = "0467cn5hqry6fscjskpvxw0y00lr059jmldv1csicbav4l0dxx8k";
  };
}
