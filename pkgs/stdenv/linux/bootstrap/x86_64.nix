# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://abbradar.net/me/pub/shlib-no-undefined/x86_64/bootstrap-tools.tar.xz;
    sha256 = "0as6mg2hpy4ck7s8hkncmfh9z01a8y93zwx18n7llzhpmf4l5qj5";
  };
}
