{
  lib,
  fetchcvs,
  version,
}:

fetchcvs {
  cvsRoot = ":pserver:anoncvs@anoncvs.NetBSD.org:/cvsroot";
  module = "src";
  tag = "netbsd-${lib.replaceStrings [ "." ] [ "-" ] version}-RELEASE";
  hash = "sha256-oI2rXIec+YEq+8WZ0Ccd8zIto7Y4+CH7Ee5vC30vSng=";
}
