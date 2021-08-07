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
in
rec {
  # Policy: use the highest stable version as the default (on our master).
  stable = if stdenv.hostPlatform.system == "x86_64-linux"
    then generic {
      version = "460.73.01";
      sha256_64bit = "120ymf59l6nipczszf82lrm2p4ihhqyv2pfwwfg9wy96vqcckc8i";
      settingsSha256 = "08jh7g34p9yxv5fh1cw0r2pjx65ryiv3w2lk1qg0gxn2r7xypkx0";
      persistencedSha256 = "040gx4wqp3hxcfb4aba4sl7b01ixr5slhzw0xldwcqlmhpwqphi5";

      patches = [
        # Patch to allow building on 5.13+ kernels
        (fetchurl {
          url = "https://gist.githubusercontent.com/joanbm/4a9d392e6f2d45c93ef434bda78174e5/raw/60a9d3846e6ba377da8cecaf56dd8eefa35ce03d/nvidia-fix-linux-5.13.patch";
          sha256 = "bwIZmZlkp02X5SorccTtjNkWpRks61QtvvybNd+0Oqo=";

          # We put the source in kernel/ before patchPhase, so we need to fix the paths.
          postFetch = ''
            sed -i 's|--- a/|--- a/kernel/|' $out
            sed -i 's|--- b/|--- b/kernel/|' $out
          '';
        })
      ];
    }
    else legacy_390;

  beta = generic {
    version = "465.27";
    sha256_64bit = "fmn/qFve5qqqa26n4dsoOwGZ+ash5Bon3JBI8kncMXE=";
    settingsSha256 = "3BFLCx0dcrQY4Mv1joMsiVPwTPyufgsNT5pFgp1Mk/A=";
    persistencedSha256 = "HtoFGTiBnAeQyRTOMlve5poaQh63LHRD+DHJxZO+c90=";
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
}
