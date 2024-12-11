{
  symlinkJoin,
  callPackage,
  nixosTests,
}:
symlinkJoin rec {
  pname = "curl-impersonate";
  inherit (passthru.curl-impersonate-chrome) version meta;

  name = "${pname}-${version}";

  paths = [
    passthru.curl-impersonate-ff
    passthru.curl-impersonate-chrome
  ];

  passthru = {
    curl-impersonate-ff = callPackage ./firefox {};
    curl-impersonate-chrome = callPackage ./chrome {};

    inherit (passthru.curl-impersonate-chrome) src;

    tests = {inherit (nixosTests) curl-impersonate;};
  };
}
