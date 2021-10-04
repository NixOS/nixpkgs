# Latest version of lowdown, backported from unstable separately due to breaking changes
{ lowdown
, fetchurl
}:

lowdown.overrideAttrs (_: rec {
  version = "0.9.0";
  src = fetchurl {
    url = "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${version}.tar.gz";
    sha512 = "0v3l70c9mal67i369bk3q67qyn07kmclybcd5lj5ibdrrccq1jzsxn2sy39ziy77in7cygcb1lgf9vzacx9rscw94i6259fy0dpnf0h";
  };
})
