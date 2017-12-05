{ lib, callPackage, fetchurl, fetchpatch }:

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
{
  # Policy: use the highest stable version as the default (on our master).
  stable = generic {
    version = "384.98";
    sha256_32bit = "0mxvndanbyvgaflpam2li7ilsxwfh0arqi059z1hypgwp0c8iqwk";
    sha256_64bit = "1fxnqrin8clwl7g13zfnn4422ws0laraxwlvr9gqlp43k9nvc47v";
    settingsSha256 = "081fmqk0d5fxn70kky59g9n024rb79ir6f5gf31mkw8zmyzqypvd";
    persistencedSha256 = "1whhcsz6cij1c7pg4h8795rndp4rywx9k75cjlfh0s184lyi9wm2";
  };

  beta = generic {
    version = "381.22";
    sha256_32bit = "024x3c6hrivg2bkbzv1xd0585hvpa2kbn1y2gwvca7c73kpdczbv";
    sha256_64bit = "13fj9ndy5rmh410d0vi2b0crfl7rbsm6rn7cwms0frdzkyhshghs";
    settingsSha256 = "1gls187zfd201b29qfvwvqvl5gvp5wl9lq966vd28crwqh174jrh";
    persistencedSha256 = "08315rb9l932fgvy758an5vh3jgks0qc4g36xip4l32pkxd9k963";
  };


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

    prePatch = let
      debPatches = fetchurl {
        url = "mirror://debian/pool/non-free/n/nvidia-graphics-drivers-legacy-304xx/"
            + "nvidia-graphics-drivers-legacy-304xx_304.135-2.debian.tar.xz";
        sha256 = "0mhji0ssn7075q5a650idigs48kzf11pzj2ca2n07rwxg3vj6pdr";
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

  legacy_173 = callPackage ./legacy173.nix { };
}
