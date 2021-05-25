let
  warning = ''Upstream support for v20.1 ends on 2021-11-12, please upgrade.
  cockroachdb_20_2 and cockroachdb_21_1 are available in nixpkgs, see https://www.cockroachlabs.com/docs/v20.2/upgrade-cockroach-version for instructions.'';
in
self: {
  cockroachdb_20_1 = self.lib.warn warning (self.callPackage ./gopkg.nix {});
  cockroachdb_20_2 = self.callPackage ./generic.nix {
    version = "20.2.14";
    sha256 = "1s3dpbklgk08fpyq1x99pmjyw1qgl4v617cxd5axk52ah0gdh1rv";
  };
  cockroachdb_21_1 = self.callPackage ./generic.nix {
    version = "21.1.7";
    sha256 = "1br9139glgy954zjlgznc7ss9x19ssvm8lcm7w5037k1gnhdgiha";
  };
}

