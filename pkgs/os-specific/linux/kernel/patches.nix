{ stdenv, fetchurl }:

let
  grsecPatch = { grversion ? "3.1", kversion, revision, branch, sha256 }:
    { name = "grsecurity-${grversion}-${kversion}";
      inherit grversion kversion revision;
      patch = fetchurl {
        url = "http://grsecurity.net/${branch}/grsecurity-${grversion}-${kversion}-${revision}.patch";
        inherit sha256;
      };
      features.grsecurity = true;
    };

  patches = rec {
    btrfs_fix_deadlock =
      { name  = "btrfs-fix-deadlock";
        patch = ./patches/btrfs-fix-deadlock.patch;
      };

    bridge_stp_helper =
      { name = "bridge-stp-helper";
        patch = ./patches/bridge-stp-helper.patch;
      };

    grsec_fix_path =
      { name = "grsec-fix-path";
        patch = ./patches/grsec-path.patch;
      };

    grsecurity_stable = grsecPatch
      { kversion  = "3.14.37";
        revision  = "201504051405";
        branch    = "stable";
        sha256    = "0w1rz5g4wwd22ivii7m7qjgakdynzjwpqxiydx51kiw5j0avkzs3";
      };

    grsecurity_unstable = grsecPatch
      { kversion  = "3.19.3";
        revision  = "201504021826";
        branch    = "test";
        sha256    = "0r3gsha4x9bkzg9n4rcwzi9f3hkbqrf8yga1dd83kyd10fns4lzm";
      };
  };
in patches
