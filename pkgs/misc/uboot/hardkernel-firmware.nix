{ stdenv
, lib
, fetchpatch
, fetchFromGitHub
, buildPackages
, pkgsCross
}:

let
  buildHardkernelFirmware = {
    version ? null
    , src ? null
    , name ? ""
    , filesToInstall
    , installDir ? "$out"
    , defconfig
    , extraMeta ? {}
    , ... } @ args: stdenv.mkDerivation ({
      pname = "uboot-hardkernel-firmware-${name}";

      nativeBuildInputs = [
        buildPackages.git
        buildPackages.hostname
        pkgsCross.arm-embedded.stdenv.cc
      ];

      depsBuildBuild = [
        buildPackages.gcc49
      ] ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) buildPackages.stdenv.cc
        ++ lib.optional (!stdenv.isAarch64) pkgsCross.aarch64-multiplatform.buildPackages.gcc49;

      postPatch = ''
        substituteInPlace Makefile --replace "/bin/pwd" "pwd"
      '';

      makeFlags = [
        "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
        "CROSS_COMPILE_32=${pkgsCross.arm-embedded.stdenv.cc.targetPrefix}"
        "${defconfig}" "bl301.bin"
      ]
      ++ lib.optional (!stdenv.isAarch64) "CROSS_COMPILE=${pkgsCross.aarch64-multiplatform.stdenv.cc.targetPrefix}";

      installPhase = ''
        mkdir -p ${installDir}
        cp ${lib.concatStringsSep " " filesToInstall} ${installDir}
      '';

      meta = with lib; {
        homepage = "https://www.hardkernel.com/";
        description = "Das U-Boot from Hardkernel with Odroid embedded devices firmware and support";
        license = licenses.unfreeRedistributableFirmware;
        maintainers = with maintainers; [ aarapov ];
      } // extraMeta;
    } // removeAttrs args [ "extraMeta" ]);
in {
  inherit buildHardkernelFirmware;

  firmwareOdroidC2 = buildHardkernelFirmware {
    defconfig = "odroidc2_config";
    name = "firmware-odroid-c2";
    version = "2015.01";
    src = fetchFromGitHub {
      owner = "hardkernel";
      repo = "u-boot";
      rev = "fac4d2da0a1b61dfdeaca0034a45151ff5983fb8";
      sha256 = "09s0y69ilrwnvqi1g11axsnhylq8kfljwqxdfjifa227mi0kzq37";
    };

    # https://wiki.odroid.com/odroid-c2/software/building_u-boot
    prePatch = ''
      patch -p1 < ${fetchpatch {
        url = "https://github.com/hardkernel/u-boot_firmware/commit/5ce504067bb83de03d17173d5585e849df5d5a33.patch";
        sha256 = "0m9slsv7lwm2cf2akmx1x6mqzmfckrvw1r0nls91w6g40982qwly";
      }}
      patch -p1 < ${fetchpatch {
        url = "https://github.com/hardkernel/u-boot_firmware/commit/0002fa877ca919e808e5fb7675194f17abde5d8d.patch";
        sha256 = "0hr6037xl69v9clch8i3vr80vgfn453wcvza630mzifkkn2d1fh8";
      }}
      patch -p1 < ${fetchpatch {
        url = "https://github.com/hardkernel/u-boot_firmware/commit/b129006d2bdd0aee3bc78593f9401b0873e6baf9.patch";
        sha256 = "1bj7mb6h8njpvimjbjgv801ay97gwdgg9cd1hlv39fwqvv1nzfir";
      }}
      patch -p1 < ${fetchpatch {
        url = "https://github.com/hardkernel/u-boot_firmware/commit/d3642b8329a605f641046cf25aeba935fa2f06dc.patch";
        sha256 = "0iw06zvw8407s3r3n6v89z6jj8r6lwy0qm1izhf815qi3wxh55pq";
      }}
      patch -p1 < ${fetchpatch {
        url = "https://github.com/hardkernel/u-boot_firmware/commit/911ab14f86b7c820aa3fe310b7eb7be0398292b1.patch";
        sha256 = "1sq4mynw6iivx2xm0hp55x7r58bvfgav62d169q5mwgi9imbv6kg";
      }}
      patch -p1 < ${fetchpatch {
        url = "https://github.com/hardkernel/u-boot_firmware/commit/b7b90c1099b057d35ebae886b7846b5d9bfb4143.patch";
        sha256 = "17x5fc2rphgz6jybya7yk35j4h9iq0b7cnq2qhkq3lpw2060ldlg";
      }}

      substituteInPlace ./arch/arm/cpu/armv8/gxb/firmware/scp_task/Makefile \
        --replace "CROSS_COMPILE" "CROSS_COMPILE_32"
    '';

    filesToInstall = [
      "build/scp_task/bl301.bin" "fip/gxb/bl30.bin" "fip/gxb/bl2.package"
      "sd_fuse/sd_fusing.sh" "sd_fuse/bl1.bin.hardkernel"
    ];

    extraMeta.platforms = [ "aarch64-linux" ];
  };

  # https://wiki.odroid.com/odroid-c4/software/building_u-boot
  firmwareOdroidC4 = buildHardkernelFirmware {
    name = "firmware-odroid-c4";
    defconfig = "odroidc4_defconfig";
    version = "2015.01";
    src = fetchFromGitHub {
      owner = "hardkernel";
      repo = "u-boot";
      rev = "90ebb7015c1bfbbf120b2b94273977f558a5da46";
      sha256 = "0kv9hpsgpbikp370wknbyj6r6cyhp7hng3ng6xzzqaw13yy4qiz9";
    };

    prePatch = ''
      substituteInPlace ./arch/arm/cpu/armv8/g12a/firmware/scp_task/Makefile \
        --replace "CROSS_COMPILE" "CROSS_COMPILE_32"
    '';

    filesToInstall = [
      "build/board/hardkernel/odroidc4/firmware/acs.bin" "build/scp_task/bl301.bin"
      "fip/g12a/bl2.bin" "fip/g12a/bl30.bin" "fip/g12a/bl31.img"
      "fip/g12a/ddr3_1d.fw" "fip/g12a/ddr4_1d.fw" "fip/g12a/ddr4_2d.fw"
      "fip/g12a/lpddr3_1d.fw" "fip/g12a/lpddr4_1d.fw" "fip/g12a/lpddr4_2d.fw"
      "fip/g12a/diag_lpddr4.fw" "fip/g12a/piei.fw" "fip/g12a/aml_ddr.fw"
      "fip/g12a/aml_encrypt_g12a" "sd_fuse/sd_fusing.sh"
    ];

    # Even though Odroid C4 firmware blobs are buildable on aarch64, we can not
    # use it to produce U-Boot loader binary on aarch64 machines. This is
    # because we do not have "aml_encrypt_g12a" binary compiled for aarch64.
    # So that "x86_64-linux" makes more sense here, though we have to keep
    # "aarch64-linux" in order to make this derivative consumable by ubootOdroidC4
    # derivative.
    extraMeta.platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
