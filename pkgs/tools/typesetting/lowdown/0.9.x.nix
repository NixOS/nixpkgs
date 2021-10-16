# Latest version of lowdown, backported from unstable separately due to breaking changes
{ lowdown
, fetchurl
}:

lowdown.overrideAttrs (_: rec {
  version = "0.9.2";
  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "2dnjyx3q46n7v1wl46vfgs9rhb3kvhijsd3ydq6amdf6vlf4mf1zsiakd5iycdh0i799zq61yspsibc87mcrs8l289lnwl955avs068";
  };
})
