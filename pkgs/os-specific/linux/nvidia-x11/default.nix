{ lib, callPackage, fetchpatch, fetchurl, stdenv, pkgsi686Linux }:

let
  generic = args: let
    imported = import ./generic.nix args;
  in if ((!lib.versionOlder args.version "391")
    && stdenv.hostPlatform.system != "x86_64-linux") then null
  else callPackage imported {
    lib32 = (pkgsi686Linux.callPackage imported {
      libsOnly = true;
      kernel = null;
    }).out;
  };

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
  stable = if stdenv.hostPlatform.system == "x86_64-linux"
    then generic {
      version = "460.73.01";
      sha256_64bit = "120ymf59l6nipczszf82lrm2p4ihhqyv2pfwwfg9wy96vqcckc8i";
      settingsSha256 = "08jh7g34p9yxv5fh1cw0r2pjx65ryiv3w2lk1qg0gxn2r7xypkx0";
      persistencedSha256 = "040gx4wqp3hxcfb4aba4sl7b01ixr5slhzw0xldwcqlmhpwqphi5";
    }
    else legacy_390;

  beta = generic {
    version = "460.27.04";
    sha256_64bit = "plTqtc5QZQwM0f3MeMZV0N5XOiuSXCCDklL/qyy8HM8=";
    settingsSha256 = "hU9J0VSrLXs7N14zq6U5LbBLZXEIyTfih/Bj6eFcMf0=";
    persistencedSha256 = "PmqhoPskqhJe2FxMrQh9zX1BWQCR2kkfDwvA89+XALA=";
  };

  # Vulkan developer beta driver
  # See here for more information: https://developer.nvidia.com/vulkan-driver
  vulkan_beta = generic rec {
    version = "455.46.04";
    persistencedVersion = "455.45.01";
    settingsVersion = "455.45.01";
    sha256_64bit = "1iv42w3x1vc00bgn6y4w1hnfsvnh6bvj3vcrq8hw47760sqwa4xa";
    settingsSha256 = "09v86y2c8xas9ql0bqr7vrjxx3if6javccwjzyly11dzffm02h7g";
    persistencedSha256 = "13s4b73il0lq2hs81q03176n16mng737bfsp3bxnxgnrv3whrayz";
    url = "https://developer.nvidia.com/vulkan-beta-${lib.concatStrings (lib.splitString "." version)}-linux";
  };

  # Last one supporting x86
  legacy_390 = generic {
    version = "390.143";
    sha256_32bit = "AelrdTTeo/3+ZdXK0iniZDB8gJUkeZQtNoRm25z+bQY=";
    sha256_64bit = "tyKqcPM71ErK8ZZHLPtxmgrWzv6tfEmxBRveCSwTlO8=";
    settingsSha256 = "EJPXZbxZS1CMENAYk9dCAIsHsRTXJpj473+JLuhGkWI=";
    persistencedSha256 = "FtlPF3jCNr18NnImTmr8zJsaK9wbj/aWZ9LwoLr5SeE=";
  };

  legacy_340 = generic {
    version = "340.108";
    sha256_32bit = "1jkwa1phf0x4sgw8pvr9d6krmmr3wkgwyygrxhdazwyr2bbalci0";
    sha256_64bit = "06xp6c0sa7v1b82gf0pq0i5p0vdhmm3v964v0ypw36y0nzqx8wf6";
    settingsSha256 = "0zm29jcf0mp1nykcravnzb5isypm8l8mg2gpsvwxipb7nk1ivy34";
    persistencedSha256 = "1ax4xn3nmxg1y6immq933cqzw6cj04x93saiasdc0kjlv0pvvnkn";
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
    broken = lib.versionAtLeast kernel.version "4.18";
  };
}
