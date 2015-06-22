{ stdenv, fetchzip }:

let full = stdenv.lib.overrideDerivation (fetchzip {
  url = "https://github.com/samdmarshall/OSXPrivateSDK/tarball/69bf3c7f7140ed6ab2b6684b427bd457209858fe";
  name = "osx-private-sdk-10.9";
  sha256 = "1agl4kyry6m7yz3sql5mrbvmd1xkmb4nbq976phcpk19inans1zm";
}) (drv: {
  postFetch = ''
    unpackFile() {
      tar xzf "$1"
    }
  '' + drv.postFetch;
}); in {
  outPath = "${full}/PrivateSDK10.9";
  passthru.sdk10 = "${full}/PrivateSDK10.10";
}
