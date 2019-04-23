{ lib, callPackage, fetchurl, stdenv }:

let
  generic = args: callPackage (import ./generic.nix args) { };
  kernel = callPackage # a hacky way of extracting parameters from callPackage
    ({ kernel, libsOnly ? false }: if libsOnly then { } else kernel) { };

  maybePatch_drm_legacy =
    lib.optional (lib.versionOlder "4.14" (kernel.version or "0"))
      (fetchurl {
        url = "https://raw.githubusercontent.com/MilhouseVH/LibreELEC.tv/b5d2d6a1"
            + "/packages/x11/driver/xf86-video-nvidia-legacy/patches/"
            + "xf86-video-nvidia-legacy-0010-kernel-4.14.patch";
        sha256 = "18clfpw03g8dxm61bmdkmccyaxir3gnq451z6xqa2ilm3j820aa5";
      });
in
rec {
  # Policy: use the highest stable version as the default (on our master).
  stable = if stdenv.hostPlatform.system == "x86_64-linux" then stable_418 else legacy_390;

  # No active beta right now
  beta = generic {
    version = "430.09";
    sha256_64bit = "0k59ahljya286ararncf3mc7sfgsw82vnrszczqicpysn3qfar95";
    settingsSha256 = "082v0xmz83sf4wdvcb2zawddy5vh3pbwjz0fda1rayc7fdadni05";
    persistencedSha256 = "028vs23mnb345sxjxqqmln9pwq8n6cc6dhfzq4hj21ghc6l6fg54";
  };

  stable_418 = generic {
    version = "418.56";
    sha256_64bit = "1cg7927g5ml1rwgpydlrjzr55gza5dfkqkch29bbarpzd7dh0mf4";
    settingsSha256 = "150c64wbijwyq032ircl1b78q0gwdvfq35gxaqw00d3ac2hjwpsg";
    persistencedSha256 = "07wh6v8c2si0zwy9j60yzrdn1b1pm0vr9kfvql3jkyjqfn4np44z";
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.116";
    sha256_32bit = "0aavzi99ps7r6nrchf4h9gw3fkvm2z6wppkqkz5fwcy7x03ky4qk";
    sha256_64bit = "106qc62a7m9imchqfq8rfn8fwyrjxg383354q7z2wr8112fyhyg1";
    settingsSha256 = "0n4pj8dzkr7ccwrn5p46mn59cnijdhg8zmn3idjzrk56pq0hbgjr";
    persistencedSha256 = "0bnjr0smhlwlqpyg9m6lca3b7brl2mw8aypc6p7525dn9d9kv6kb";

    patches = lib.optional (kernel.meta.branch == "4.19") ./drm_mode_connector.patch;
  };

  legacy_340 = generic {
    version = "340.107";
    sha256_32bit = "0mh83affz6bim26ws7kkwwcfj2s6vkdy4d45hifsbshr82qd52wd";
    sha256_64bit = "0pv9yv3x0kg9hfkmc50xb54ahxkbnyy2vyy4hj2h0s6m9sb5kqz3";
    settingsSha256 = "1zf0fy9jj6ipm5vk153swpixqm75iricmx7x49pmr97kzyczaxa7";
    persistencedSha256 = "0v225jkiqk9rma6whxs1a4fyr4haa75bvi52ss3vsyn62zzl24na";
    useGLVND = false;

    patches = [ ./vm_operations_struct-fault.patch ];
  };

  legacy_304 = generic {
    version = "304.137";
    sha256_32bit = "1y34c2gvmmacxk2c72d4hsysszncgfndc4s1nzldy2q9qagkg66a";
    sha256_64bit = "1qp3jv6279k83k3z96p6vg3dd35y9bhmlyyyrkii7sib7bdmc7zb";
    settingsSha256 = "129f0j0hxzjd7g67qwxn463rxp295fsq8lycwm6272qykmab46cj";
    persistencedSha256 = null;
    useGLVND = false;
    useProfiles = false;
    settings32Bit = true;

    prePatch = let
      debPatches = fetchurl {
        url = "mirror://debian/pool/non-free/n/nvidia-graphics-drivers-legacy-304xx/"
            + "nvidia-graphics-drivers-legacy-304xx_304.137-5.debian.tar.xz";
        sha256 = "0n8512mfcnvklfbg8gv4lzbkm3z6nncwj6ix2b8ngdkmc04f3b6l";
      };
      prefix = "debian/module/debian/patches";
      applyPatches = pnames: if pnames == [] then null else
        ''
          tar xf '${debPatches}'
          sed 's|^\([+-]\{3\} [ab]\)/|\1/kernel/|' -i ${prefix}/*.patch
          patches="$patches ${lib.concatMapStringsSep " " (pname: "${prefix}/${pname}.patch") pnames}"
        '';
    in applyPatches [ "fix-typos" ];
    patches = maybePatch_drm_legacy;
    broken = stdenv.lib.versionAtLeast kernel.version "4.18";
  };
}
