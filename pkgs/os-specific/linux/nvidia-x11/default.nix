{ lib, callPackage, fetchurl, fetchpatch }:

let
  generic = args: callPackage (import ./generic.nix args) { };
in
{
  # Policy: use the highest stable version as the default (on our master).
  stable = generic {
    version = "375.66";
    sha256_32bit = "0k7ib5ah3c2apzgzxlq75l48zm8901mbwj7slv18k3rhk8j0w8i9";
    sha256_64bit = "1h01s8brpz42jwc24dsflm4psd3zsy26ds98h0adgwx51dbpzqsr";
    settingsSha256 = "0bpdayyqw4cpgl7bgddfz6w5j8y3wsgr89p5vxnzgk9g0vgqxh5h";
    persistencedSha256 = "113rllf9l26z546jjfijpxllp17qcpawblzxvsqc6rbzbkmvcdwi";
  };

  beta = generic {
    version = "381.22";
    sha256_32bit = "024x3c6hrivg2bkbzv1xd0585hvpa2kbn1y2gwvca7c73kpdczbv";
    sha256_64bit = "13fj9ndy5rmh410d0vi2b0crfl7rbsm6rn7cwms0frdzkyhshghs";
    settingsSha256 = "1gls187zfd201b29qfvwvqvl5gvp5wl9lq966vd28crwqh174jrh";
    persistencedSha256 = "08315rb9l932fgvy758an5vh3jgks0qc4g36xip4l32pkxd9k963";
  };

  legacy_340 = generic {
    version = "340.102";
    sha256_32bit = "0a484i37j00d0rc60q0bp6fd2wfrx2c4r32di9w5svqgmrfkvcb1";
    sha256_64bit = "0nnz51d48a5fpnnmlz1znjp937k3nshdq46fw1qm8h00dkrd55ib";
    settingsSha256 = "0nm5c06b09p6wsxpyfaqrzsnal3p1047lk6p4p2a0vksb7id9598";
    persistencedSha256 = "1jwmggbph9zd8fj4syihldp2a5bxff7q1i2l9c55xz8cvk0rx08i";
    useGLVND = false;

    patches = [
      (fetchpatch {
        name = "kernel-4.10.patch";
        url = https://git.archlinux.org/svntogit/packages.git/plain/nvidia-340xx/trunk/4.10.0_kernel.patch?id=53fb1df89;
        sha256 = "171hb57m968qdjcr3h8ppfzhrchf573f39rdja86a1qq1gmrv7pa";
      })
      # from https://git.archlinux.org/svntogit/packages.git/plain/trunk/fs52243.patch?h=packages/nvidia-340xx
      # with datestamps removed
      ./fs52243.patch
    ];
  };

  legacy_304 = generic {
    version = "304.135";
    sha256_32bit = "14qdl39wird04sqba94dcb77i63igmxxav62ndr4qyyavn8s3c2w";
    sha256_64bit = "125mianhvq591np7y5jjrv9vmpbvixnkicr49ni48mcr0yjnjqkh";
    settingsSha256 = "1y7swikdngq4nlwzkrq20yfah9zr31n1a5i6nw37awnp8xjilhzm";
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
    in applyPatches [ "fix-typos" "drm-driver-legacy" "deprecated-cpu-events" "disable-mtrr" ];
  };

  legacy_173 = callPackage ./legacy173.nix { };
}
