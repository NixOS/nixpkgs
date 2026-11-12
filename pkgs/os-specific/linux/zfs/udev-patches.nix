{ fetchurl }:

[
  (fetchurl {
    url = "https://github.com/openzfs/zfs/commit/d72c4549082eea1745ed9ca7c3c4232fe38a8090.patch";
    hash = "sha256-rZgUAt5GBuQTRAiI3Qt51JzenYhJ0m9778PFh5z3uwM=";
  })
  (fetchurl {
    url = "https://github.com/openzfs/zfs/commit/05676ee21e764f487f46a18e07c0396c1538c89d.patch";
    hash = "sha256-FH/0EvseC5fL1reMdiDxP2bD6QznGlFvBU9QIa35Z60=";
  })
]
