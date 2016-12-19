{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."commander"."1.3.1" =
    self.by-version."commander"."1.3.1";
  by-version."commander"."1.3.1" = self.buildNodePackage {
    name = "commander-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/commander/-/commander-1.3.1.tgz";
      name = "commander-1.3.1.tgz";
      sha1 = "02443e02db96f4b32b674225451abb6e9510000e";
    };
    deps = {
      "keypress-0.1.0" = self.by-version."keypress"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."connection-parse"."0.0.x" =
    self.by-version."connection-parse"."0.0.7";
  by-version."connection-parse"."0.0.7" = self.buildNodePackage {
    name = "connection-parse-0.0.7";
    version = "0.0.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/connection-parse/-/connection-parse-0.0.7.tgz";
      name = "connection-parse-0.0.7.tgz";
      sha1 = "18e7318aab06a699267372b10c5226d25a1c9a69";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generic-pool"."2.2.0" =
    self.by-version."generic-pool"."2.2.0";
  by-version."generic-pool"."2.2.0" = self.buildNodePackage {
    name = "generic-pool-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/generic-pool/-/generic-pool-2.2.0.tgz";
      name = "generic-pool-2.2.0.tgz";
      sha1 = "8b465c1a7588ea9dd2bb133bda0bb66bfef8a63e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hashring"."3.2.0" =
    self.by-version."hashring"."3.2.0";
  by-version."hashring"."3.2.0" = self.buildNodePackage {
    name = "hashring-3.2.0";
    version = "3.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hashring/-/hashring-3.2.0.tgz";
      name = "hashring-3.2.0.tgz";
      sha1 = "fda4efde8aa22cdb97fb1d2a65e88401e1c144ce";
    };
    deps = {
      "connection-parse-0.0.7" = self.by-version."connection-parse"."0.0.7";
      "simple-lru-cache-0.0.2" = self.by-version."simple-lru-cache"."0.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."keypress"."0.1.x" =
    self.by-version."keypress"."0.1.0";
  by-version."keypress"."0.1.0" = self.buildNodePackage {
    name = "keypress-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/keypress/-/keypress-0.1.0.tgz";
      name = "keypress-0.1.0.tgz";
      sha1 = "4a3188d4291b66b4f65edb99f806aa9ae293592a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."modern-syslog"."1.1.2" =
    self.by-version."modern-syslog"."1.1.2";
  by-version."modern-syslog"."1.1.2" = self.buildNodePackage {
    name = "modern-syslog-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/modern-syslog/-/modern-syslog-1.1.2.tgz";
      name = "modern-syslog-1.1.2.tgz";
      sha1 = "f1fa58899f3f452d788f1573401212a4ef898de5";
    };
    deps = {
      "nan-2.4.0" = self.by-version."nan"."2.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ "!win32" ];
    cpu = [ ];
  };
  by-spec."nan"."^2.0.5" =
    self.by-version."nan"."2.4.0";
  by-version."nan"."2.4.0" = self.buildNodePackage {
    name = "nan-2.4.0";
    version = "2.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nan/-/nan-2.4.0.tgz";
      name = "nan-2.4.0.tgz";
      sha1 = "fb3c59d45fe4effe215f0b890f8adf6eb32d2232";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sequence"."2.2.1" =
    self.by-version."sequence"."2.2.1";
  by-version."sequence"."2.2.1" = self.buildNodePackage {
    name = "sequence-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sequence/-/sequence-2.2.1.tgz";
      name = "sequence-2.2.1.tgz";
      sha1 = "7f5617895d44351c0a047e764467690490a16b03";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."simple-lru-cache"."0.0.x" =
    self.by-version."simple-lru-cache"."0.0.2";
  by-version."simple-lru-cache"."0.0.2" = self.buildNodePackage {
    name = "simple-lru-cache-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/simple-lru-cache/-/simple-lru-cache-0.0.2.tgz";
      name = "simple-lru-cache-0.0.2.tgz";
      sha1 = "d59cc3a193c1a5d0320f84ee732f6e4713e511dd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stackdriver-statsd-backend"."*" =
    self.by-version."stackdriver-statsd-backend"."0.2.3";
  by-version."stackdriver-statsd-backend"."0.2.3" = self.buildNodePackage {
    name = "stackdriver-statsd-backend-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stackdriver-statsd-backend/-/stackdriver-statsd-backend-0.2.3.tgz";
      name = "stackdriver-statsd-backend-0.2.3.tgz";
      sha1 = "6ffead71e5655d4d787c39da8d1c9eaaa59c91d7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "stackdriver-statsd-backend" = self.by-version."stackdriver-statsd-backend"."0.2.3";
  by-spec."statsd"."*" =
    self.by-version."statsd"."0.8.0";
  by-version."statsd"."0.8.0" = self.buildNodePackage {
    name = "statsd-0.8.0";
    version = "0.8.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/statsd/-/statsd-0.8.0.tgz";
      name = "statsd-0.8.0.tgz";
      sha1 = "92041479e174a214df7147f2fab1348af0839052";
    };
    deps = {
      "generic-pool-2.2.0" = self.by-version."generic-pool"."2.2.0";
    };
    optionalDependencies = {
      "modern-syslog-1.1.2" = self.by-version."modern-syslog"."1.1.2";
      "hashring-3.2.0" = self.by-version."hashring"."3.2.0";
      "winser-0.1.6" = self.by-version."winser"."0.1.6";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "statsd" = self.by-version."statsd"."0.8.0";
  by-spec."statsd-influxdb-backend"."*" =
    self.by-version."statsd-influxdb-backend"."0.6.0";
  by-version."statsd-influxdb-backend"."0.6.0" = self.buildNodePackage {
    name = "statsd-influxdb-backend-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/statsd-influxdb-backend/-/statsd-influxdb-backend-0.6.0.tgz";
      name = "statsd-influxdb-backend-0.6.0.tgz";
      sha1 = "25fb83cf0b3af923dfc7d506eb1208def8790d78";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "statsd-influxdb-backend" = self.by-version."statsd-influxdb-backend"."0.6.0";
  by-spec."statsd-librato-backend"."*" =
    self.by-version."statsd-librato-backend"."0.1.7";
  by-version."statsd-librato-backend"."0.1.7" = self.buildNodePackage {
    name = "statsd-librato-backend-0.1.7";
    version = "0.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/statsd-librato-backend/-/statsd-librato-backend-0.1.7.tgz";
      name = "statsd-librato-backend-0.1.7.tgz";
      sha1 = "270dc406481c0e6a6f4e72957681a73015f478f6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "statsd-librato-backend" = self.by-version."statsd-librato-backend"."0.1.7";
  by-spec."winser"."=0.1.6" =
    self.by-version."winser"."0.1.6";
  by-version."winser"."0.1.6" = self.buildNodePackage {
    name = "winser-0.1.6";
    version = "0.1.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/winser/-/winser-0.1.6.tgz";
      name = "winser-0.1.6.tgz";
      sha1 = "08663dc32878a12bbce162d840da5097b48466c9";
    };
    deps = {
      "sequence-2.2.1" = self.by-version."sequence"."2.2.1";
      "commander-1.3.1" = self.by-version."commander"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}
