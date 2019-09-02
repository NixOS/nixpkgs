{ lib, callPackage, fetchurl, stdenv }:

let

generic = args:
if ((!lib.versionOlder args.version "391")
    && stdenv.hostPlatform.system != "x86_64-linux") then null
  else callPackage (import ./generic.nix args) { };
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
  stable = if stdenv.hostPlatform.system == "x86_64-linux" then stable_43x else legacy_390;

  # No active beta right now
  beta = stable;

  stable_43x = generic {
    version = "435.21";
    sha256_64bit = "0v3pq677ab01qdmwl5dawk8hn39qlwj05p8s9qzh9irmrlnc1izs";
    settingsSha256 = "1p13cz79kncwx5067a3d7dbz6a1ibp611zynp1qdxpa65hwp2pxa";
    persistencedSha256 = "0br8znxhz2ryzdj0j4jhqzvdgw9h899q8yz0p9429xz4wxkavgdr";
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.129";
    sha256_32bit = "0dkgkp0zx40hf1fsq5xnvbschp7r3c1x1pnpdxna24pi4s62cm2q";
    sha256_64bit = "0h0jcckqpd63vaj95lvdgj2sbbn9y1ri1xx7r2snxfx0plhwz46n";
    settingsSha256 = "1w5nkxs7a40mq0qf97nhfazdqhfn1bvr54v50s8p0ggixb6vdm3l";
    persistencedSha256 = "02v76202qcnh8hvg4y9wmk9swdlv7z39ppfd1c850nlv158vn5nf";

    patches = [
      (fetchurl {
        url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/kernel-4.16.patch?h=2ad07241ea525a6b6b555b6cb96a97634a4b2cb0";
        sha256 = "11b3dp0na496rn13v5q4k66bf61174800g36rcwj42r0xj9cfak2";
      })

      (fetchurl {
        url = "https://git.archlinux.org/svntogit/packages.git/plain/trunk/kernel-5.1.patch?h=42d50ef8d6048608d18bdf2c296dd335260c5a1a";
        sha256 = "03v46ym2bcckg9q2xrilkg21hfiwypr6gl4jmly2q3m4yza9ja6r";
      })
    ];
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
