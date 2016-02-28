{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."wring"."*" =
    self.by-version."wring"."1.0.0";
  by-version."wring"."1.0.0" = self.buildNodePackage {
    name = "wring-1.0.0";
    version = "1.0.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/wring/-/wring-1.0.0.tgz";
      name = "wring-1.0.0.tgz";
      sha1 = "3d8ebe894545bf0b42946fdc84c61e37ae657ce1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "wring" = self.by-version."wring"."1.0.0";
}
