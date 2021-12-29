# https://www.cockroachlabs.com/docs/releases/release-support-policy.html

{ callPackage }: {
  # Maintenance Support Ends: 2021-11-10
  # EOL: 2022-05-10
  cockroachdb_20_2 = callPackage ./generic.nix {
    version = "20.2.18";
    sha256 = "1m850w1lm8x14yj2b6l3yvma0dbr6l4lislhy7d2yl37pgbg6s60";
  };

  # Maintenance Support Ends: 2022-05-18
  # EOL: 2022-11-18
  cockroachdb_21_1 = callPackage ./generic.nix {
    version = "21.1.13";
    sha256 = "1npqh75w1x2jjmy512jxqlr4caam96lw74gfs8kdq0iaw6hkh3y2";
  };

  # Maintenance Support Ends: 2022-11-16
  # EOL: 2023-05-16
  cockroachdb_21_2 = callPackage ./generic.nix {
    version = "21.2.4";
    sha256 = "1zflfn4fszg6b1g2z3pw16gni6aismm35n3d87vchasb1l5gvryx";
    patches = [ ./redacted.patch ];
  };
}
