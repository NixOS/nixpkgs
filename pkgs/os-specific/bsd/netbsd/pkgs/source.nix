{
  lib,
  fetchcvs,
  version,
}:

fetchcvs {
  cvsRoot = ":pserver:anoncvs@anoncvs.NetBSD.org:/cvsroot";
  module = "src";
  tag = "netbsd-${lib.replaceStrings [ "." ] [ "-" ] version}-RELEASE";
  hash = "sha256-+onT/ajWayaKALucaZBqoiEkvBBI400Fs2OCtMf/bYU=";
}
