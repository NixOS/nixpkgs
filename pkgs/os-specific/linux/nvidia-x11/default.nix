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
  stable = if stdenv.hostPlatform.system == "x86_64-linux" then stable_410 else stable_390;

  stable_410 = generic {
    version = "410.73";
    sha256_64bit = "07pzq8rvbsx3v8rgz98amyw0k1mn5mkygpd1q5gfn6r0h7vrrg5y";
    settingsSha256 = "19xc10b0c074wb9fv9n04dvmi8hrwl6srvvyrjfyj92gch49x6hw";
    persistencedSha256 = "0vhr7pysv4vk7v96yima0i9zsvvgxaxihjzxlfifpsdki57n2jz7";
  };

  # Last one supporting x86
  stable_390 = generic {
    version = "390.87";
    sha256_32bit = "0rlr1f4lnpb8c4qz4w5r8xw5gdy9bzz26qww45qyl1qav3wwaaaw";
    sha256_64bit = "07k1kq8lkgbvjyr2dnbxcz6nppcwpq17wf925w8kfq78345hla9q";
    settingsSha256 = "0xlaiy7jr95z0v2c6cwll89nxnb142pybw7m08jg44r7n13ffv3r";
    persistencedSha256 = "0mhwk321garyl6m12261cj03ycv0qz1sbrlbq6cqwjpq4f1s7h58";

    patches = lib.optional (kernel.meta.branch == "4.19") ./drm_mode_connector.patch;
  };

  # No active beta right now
  beta = stable;

  legacy_340 = generic {
    version = "340.104";
    sha256_32bit = "1l8w95qpxmkw33c4lsf5ar9w2fkhky4x23rlpqvp1j66wbw1b473";
    sha256_64bit = "18k65gx6jg956zxyfz31xdp914sq3msn665a759bdbryksbk3wds";
    settingsSha256 = "1vvpqimvld2iyfjgb9wvs7ca0b0f68jzfdpr0icbyxk4vhsq7sxk";
    persistencedSha256 = "0zqws2vsrxbxhv6z0nn2galnghcsilcn3s0f70bpm6jqj9wzy7x8";
    useGLVND = false;

    patches = maybePatch_drm_legacy ++ [ ./vm_operations_struct-fault.patch ];
  };

  legacy_304 = generic {
    version = "304.137";
    sha256_32bit = "1y34c2gvmmacxk2c72d4hsysszncgfndc4s1nzldy2q9qagkg66a";
    sha256_64bit = "1qp3jv6279k83k3z96p6vg3dd35y9bhmlyyyrkii7sib7bdmc7zb";
    settingsSha256 = "0i5znfq6jkabgi8xpcy12pdpww6a67i8mq60z1kjq36mmnb25pmi";
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
  };
}
