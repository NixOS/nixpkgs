{
  lib,
  stdenv,
  fetchgit,
  flex,
  bison,
  python3,
  autoconf,
  automake,
  libtool,
  bash,
  gettext,
  ncurses,
  libusb-compat-0_1,
  freetype,
  qemu,
  lvm2,
  unifont,
  pkg-config,
  help2man,
  fetchzip,
  fetchpatch,
  buildPackages,
  nixosTests,
  fuse, # only needed for grub-mount
  runtimeShell,
  zfs ? null,
  efiSupport ? false,
  zfsSupport ? false,
  xenSupport ? false,
  xenPvhSupport ? false,
  kbdcompSupport ? false,
  ckbcomp,
}:

let
  pcSystems = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386";
  };

  efiSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "aarch64";
    loongarch64-linux.target = "loongarch64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };

  # For aarch64, we need to use '--target=aarch64-efi' when building,
  # but '--target=arm64-efi' when installing. Insanity!
  efiSystemsInstall = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    armv7l-linux.target = "arm";
    aarch64-linux.target = "arm64";
    loongarch64-linux.target = "loongarch64";
    riscv32-linux.target = "riscv32";
    riscv64-linux.target = "riscv64";
  };

  xenSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
  };

  xenPvhSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386"; # Xen PVH is only i386 on x86.
  };

  inPCSystems = lib.any (system: stdenv.hostPlatform.system == system) (lib.attrNames pcSystems);

  gnulib = fetchgit {
    url = "https://git.savannah.gnu.org/git/gnulib.git";
    # NOTE: keep in sync with bootstrap.conf!
    rev = "9f48fb992a3d7e96610c4ce8be969cff2d61a01b";
    hash = "sha256-mzbF66SNqcSlI+xmjpKpNMwzi13yEWoc1Fl7p4snTto=";
  };

  # The locales are fetched from translationproject.org at build time,
  # but those translations are not versioned/stable. For that reason
  # we take them from the nearest release tarball instead:
  locales = fetchzip {
    url = "https://ftp.gnu.org/gnu/grub/grub-2.12.tar.gz";
    hash = "sha256-IoRiJHNQ58y0UhCAD0CrpFiI8Mz1upzAtyh5K4Njh/w=";
  };
in

assert zfsSupport -> zfs != null;
assert !(efiSupport && (xenSupport || xenPvhSupport));
assert !(xenSupport && xenPvhSupport);

stdenv.mkDerivation rec {
  pname = "grub";
  version = "2.12";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/grub.git";
    tag = "grub-${version}";
    hash = "sha256-lathsBb2f7urh8R86ihpTdwo3h1hAHnRiHd5gCLVpBc=";
  };

  patches = [
    ./fix-bash-completion.patch
    ./add-hidden-menu-entries.patch

    # https://lists.gnu.org/archive/html/grub-devel/2025-02/msg00024.html
    (fetchpatch {
      name = "01_implement_grub_strlcpy.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=ea703528a8581a2ea7e0bad424a70fdf0aec7d8f";
      hash = "sha256-MSMgu1vMG83HRImUUsTyA1YQaIhgEreGGPd+ZDWSI2I=";
    })
    (fetchpatch {
      name = "02_CVE-2024-45781.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=c1a291b01f4f1dcd6a22b61f1c81a45a966d16ba";
      hash = "sha256-q8ErK+cQzaqwSuhLRFL3AfYBkpgJq1IQmadnlmlz2yw=";
    })
    (fetchpatch {
      name = "03_CVE-2024-45782_CVE-2024-56737.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=417547c10410b714e43f08f74137c24015f8f4c3";
      hash = "sha256-mRinw27WZ2d1grzyzFGO18yXx72UVBM6Lf5cR8XJfs8=";
    })
    (fetchpatch {
      name = "04_fs_tar_initialize_name_in_grub_cpio_find_file.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=2c8ac08c99466c0697f704242363fc687f492a0d";
      hash = "sha256-EMGF0B+Fw6tSmllWUJAp1ynzWk+w2C/XM1LmXSReHWg=";
    })
    (fetchpatch {
      name = "05_CVE-2024-45780.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=0087bc6902182fe5cedce2d034c75a79cf6dd4f3";
      hash = "sha256-IlW5i4EJVoUYPu9/lb0LeytTpzltQuu5fpkFPQNIhls=";
    })
    (fetchpatch {
      name = "06_fs_f2fs_grub_errno_mount_fails.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=563436258cde64da6b974880abff1bf0959f4da3";
      hash = "sha256-Iu0RPyB+pAnqMT+MTX+TrJbYJsvYPn7jbMgE1jcLh/Q=";
    })
    (fetchpatch {
      name = "07_CVE-2024-45783.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=f7c070a2e28dfab7137db0739fb8db1dc02d8898";
      hash = "sha256-V1wh2dPeTazmad61jFtOjhq2MdoD+txPWY/AfwwyTZM=";
    })
    (fetchpatch {
      name = "08_fs_iso9660_grub_errno_mount_fails.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=965db5970811d18069b34f28f5f31ddadde90a97";
      hash = "sha256-6eN1AvZwXkJOQVcjgymy/E7QiAxzL/d0W3KlAZRqUzI=";
    })
    (fetchpatch {
      name = "09_fs_iso9660_fix_invalid_free.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=1443833a9535a5873f7de3798cf4d8389f366611";
      hash = "sha256-Gt5yMy5Vg9zrDggj3o/TLNt2vT9/6IuHg4Se2p8e8pI=";
    })
    (fetchpatch {
      name = "10_fs_jfs_fix_oob_read_jfs_getent.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=66175696f3a385b14bdf1ebcda7755834bd2d5fb";
      hash = "sha256-ETbzbc5gvf55sTLjmJOXXC9VH3qcP1Gv5seR/U9NRiY=";
    })
    (fetchpatch {
      name = "11_fs_jfs_fix_oob_read_caused_by_invalid_dir_slot_index.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=ab09fd0531f3523ac0ef833404526c98c08248f7";
      hash = "sha256-wE6niiIx4BdN800/Eegb6IbBRoMFpXq9kPvatwhWNXY=";
    })
    (fetchpatch {
      name = "12_fs_jfs_use_full_40_bits_offset_and_address_for_data_extent.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=bd999310fe67f35a66de3bfa2836da91589d04ef";
      hash = "sha256-fbC4oTEIoGWJASzJI5RXfoanrMLTfjFOI51LCUU7Ctg=";
    })
    (fetchpatch {
      name = "13_fs_jfs_inconsistent_signed_unsigned_types_usage.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=edd995a26ec98654d907a9436a296c2d82bc4b28";
      hash = "sha256-aa1G1vi4bPZejfKEqZokAZTzY9Ea2lyxTrP4drDV9tk=";
    })
    (fetchpatch {
      name = "14_fs_ext2_fix_out-of-bounds_read_for_inline_extent.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=7e2f750f0a795c4d64ec7dc7591edac8da2e978c";
      hash = "sha256-PtPqZHMU2fy7btRRaaswLyHizplxnygCzDfcg5ievOQ=";
    })
    (fetchpatch {
      name = "15_fs_ntfs_fix_out-of-bounds_read.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=aff26318783a135562b904ff09e2359893885732";
      hash = "sha256-znN6lkAB9aAhTGKR1038DzOz5nzuTp+7ylHVqRM7HeI=";
    })
    (fetchpatch {
      name = "16_fs_ntfs_track_the_end_of_the_MFT_attribute_buffer.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=237a71184a32d1ef7732f5f49ed6a89c5fe1c99a";
      hash = "sha256-0I/g0qHkWY6PArPn1UaYRhCrrh9bHknADh34v5eSjjM=";
    })
    (fetchpatch {
      name = "17_fs_ntfs_use_a_helper_function_to_access_attributes.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=048777bc29043403d077d41a81d0183767b8bc71";
      hash = "sha256-Mm49MSLqCq143r8ruLJm1QoyCoLtOlCBfqoAPwPlv8E=";
    })
    # Patch 18 (067b6d225d482280abad03944f04e30abcbdafa1) has been removed because it causes regressions
    # https://lists.gnu.org/archive/html/grub-devel/2025-03/msg00067.html
    (fetchpatch {
      name = "19_fs_xfs_fix_out-of-bounds_read.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=6ccc77b59d16578b10eaf8a4fe85c20b229f0d8a";
      hash = "sha256-FvTzFvfEi3oyxPC/dUHreyzzeVCskaUlYUjpKY/l0DE=";
    })
    (fetchpatch {
      name = "20_fs_xfs_ensuring_failing_to_mount_sets_a_grub_errno.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=d1d6b7ea58aa5a80a4c4d0666b49460056c8ef0a";
      hash = "sha256-SLdXMmYHq/gRmWrjRrOu5ZYFod84EllUL6hk+gnr3kg=";
    })
    (fetchpatch {
      name = "21_kern_file_ensure_file_data_is_set.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=a7910687294b29288ac649e71b47493c93294f17";
      hash = "sha256-DabZK9eSToEmSA9dEwtEN+URiVyS9qf6e2Y2UiMuy8Q=";
    })
    (fetchpatch {
      name = "22_kern_file_implement_filesystem_reference_counting.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=16f196874fbe360a1b3c66064ec15adadf94c57b";
      excludes = [ "grub-core/fs/erofs.c" ]; # Does not exist on 2.12
      hash = "sha256-yGU//1tPaxi+xFKZrsbUAnvgFpwtrIMG+8cPbSud4+U=";
    })
    (fetchpatch {
      name = "23_prerequisite_1_key_protector_add_key_protectors_framework.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=5d260302da672258444b01239803c8f4d753e3f3";
      hash = "sha256-5aFHzc5qXBNLEc6yzI17AH6J7EYogcXdLxk//1QgumY=";
    })
    (fetchpatch {
      name = "23_prerequisite_2_disk_cryptodisk_allow_user_to_retry_failed_passphrase.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=386b59ddb42fa3f86ddfe557113b25c8fa16f88c";
      hash = "sha256-e1kGQB7wGWvEb2bY3xIpZxE1uzTt9JOKi05jXyUm+bI=";
    })
    (fetchpatch {
      name = "23_prerequisite_3_cryptodisk_support_key_protectors.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=ad0c52784a375cecaa8715d7deadcf5d65baf173";
      hash = "sha256-+YIvUYA3fLiOFFsXDrQjqjWFluzLa7N1tv0lwq8BqCs=";
    })
    (fetchpatch {
      name = "23_prerequisite_4_cryptodisk_fallback_to_passphrase.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=6abf8af3c54abc04c4ec71c75d10fcfbc190e181";
      hash = "sha256-eMu9rW4iJucDAsTQMJD1XE6dDIcUmn02cGqIaqBbO3o=";
    })
    (fetchpatch {
      name = "23_prerequisite_5_cryptodisk_wipe_out_the_cached_keys_from_protectors.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=b35480b48e6f9506d8b7ad8a3b5206d29c24ea95";
      hash = "sha256-5L6Rr+X5Z+Ip91z8cpLcatDW1vyEoZa1icL2oMXPXuI=";
    })
    (fetchpatch {
      name = "23_prerequisite_6_cli_lock_add_build_option_to_block_command_line_interface.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=bb65d81fe320e4b20d0a9b32232a7546eb275ecc";
      hash = "sha256-HxXgtvEhtaIjXbOcxJHNpD9/NVOv3uXPnue7cagEMu8=";
    })
    (fetchpatch {
      name = "23_CVE-2024-49504.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=13febd78db3cd85dcba67d8ad03ad4d42815f11e";
      hash = "sha256-GejDL9IKbmbSUmp8F1NuvBcFAp2/W04jxmOatI5dKn8=";
    })
    (fetchpatch {
      name = "24_disk_loopback_reference_tracking_for_the_loopback.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=67f70f70a36b6e87a65f928fe1e840a12eafb7ae";
      hash = "sha256-sWBnSF3rAuY1A/IIK1Pc+BqTvyK3j7+lLEhvImtBQMA=";
    })
    (fetchpatch {
      name = "25_kern_disk_limit_recursion_depth.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=18212f0648b6de7d71d4c8f41eb4d8b78b3a299b";
      hash = "sha256-HiVzXUNs45Fxh4DSqO8wAxSBM7CaYU/bix0PVBcIHGw=";
    })
    (fetchpatch {
      name = "26_kern_partition_limit_recursion_in_part_iterate.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=8a7103fddfd6664f41081f3bb88eebbf2871da2a";
      hash = "sha256-Nw1VFRVww1VSDSBkRrnTGeaA2PKCitugM12XH6X/2YI=";
    })
    (fetchpatch {
      name = "27_script_execute_limit_the_recursion_depth.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=d8a937ccae5c6d86dc4375698afca5cefdcd01e1";
      hash = "sha256-YOAdPMZ2iBNMzIwAXFkkyTMKh4ptZUQ0J3v9EjnRlbo=";
    })
    (fetchpatch {
      name = "28_net_unregister_net_default_ip_and_net_default_mac_variables_hooks_on_unload.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=a1dd8e59da26f1a9608381d3a1a6c0f465282b1d";
      hash = "sha256-7fqdkhFqLECzhz1OLavkHrE9ktDAEmx9ZxZayNr/Eo4=";
    })
    (fetchpatch {
      name = "29_net_remove_variables_hooks_when_interface_is_unregisted.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=aa8b4d7facef7b75a2703274b1b9d4e0e734c401";
      hash = "sha256-m3VLDbJlwchV5meEpU4LJrDxBtA80qvYcVMJinHLnac=";
    })
    (fetchpatch {
      name = "30_CVE-2025-0624.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=5eef88152833062a3f7e017535372d64ac8ef7e1";
      hash = "sha256-DvhzHnenAmO9SZpi4kU+0GhyKZB4q4xQYuNJgEhJmn0=";
    })
    (fetchpatch {
      name = "31_net_tftp_fix_stack_buffer_overflow_in_tftp_open.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=0707accab1b9be5d3645d4700dde3f99209f9367";
      hash = "sha256-16NrpWFSE4jFT2uxmJg16jChw8HiGRTol25XQXNQ5l4=";
    })
    (fetchpatch {
      name = "32_CVE-2024-45774.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=2c34af908ebf4856051ed29e46d88abd2b20387f";
      hash = "sha256-OWmF+fp2TmetQjV4EWMcESW8u52Okkb5C5IPLfczyv4=";
    })
    (fetchpatch {
      name = "33_kern_dl_fix_for_an_integer_overflow_in_grub_dl_ref.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=500e5fdd82ca40412b0b73f5e5dda38e4a3af96d";
      hash = "sha256-FNqOWo+oZ4/1sCbTi2uaeKchUxwAKXtbzhScezm0yxk=";
    })
    # Patch 34 (https://git.savannah.gnu.org/cgit/grub.git/patch/?id=d72208423dcabf9eb4a3bcb17b6b31888396bd49)
    # is skipped, grub_dl_set_mem_attrs() does not exist on 2.12
    (fetchpatch {
      name = "35_kern_dl_check_for_the_SHF_INFO_LINK_flag_in_grub_dl_relocate_symbols.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=98ad84328dcabfa603dcf5bd217570aa6b4bdd99";
      hash = "sha256-Zi4Pj2NbodL0VhhO5MWhvErb8xmA7Li0ur0MxpgQjzg=";
    })
    (fetchpatch {
      name = "36_CVE-2024-45775.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=05be856a8c3aae41f5df90cab7796ab7ee34b872";
      hash = "sha256-T6DO8iuImQTP7hPaCAHMtFnheQoCkZ6w+kfNolLPmrY=";
    })
    (fetchpatch {
      name = "37_commands_ls_fix_NULL_dereference.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=0bf56bce47489c059e50e61a3db7f682d8c44b56";
      hash = "sha256-h5okwqv4ZFahP3ANUbsk1fiSV4pwEnxUExeBgQ4tiTI=";
    })
    (fetchpatch {
      name = "38_CVE-2025-0622.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=2123c5bca7e21fbeb0263df4597ddd7054700726";
      hash = "sha256-tFE7VgImGZWDICyvHbrI1hqW6/XohgdTmk21MzljMGw=";
    })
    (fetchpatch {
      name = "39_CVE-2025-0622.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=9c16197734ada8d0838407eebe081117799bfe67";
      hash = "sha256-tTeuEvadKbXVuY0m0dKtTr11Lpb3yQi4zk0bpwrMOeA=";
    })
    (fetchpatch {
      name = "40_CVE-2025-0622.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=7580addfc8c94cedb0cdfd7a1fd65b539215e637";
      hash = "sha256-khRLpWqE7hzzoqssVkGFMjAv09T+uHn13Q9pCpogMms=";
    })
    (fetchpatch {
      name = "41_CVE-2024-45776.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=09bd6eb58b0f71ec273916070fa1e2de16897a91";
      hash = "sha256-yrl/6XUdKQg/MLe8KFuFoRRbQSyOhDmyvnWBV+sr3EY=";
    })
    (fetchpatch {
      name = "42_CVE-2024-45777.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=b970a5ed967816bbca8225994cd0ee2557bad515";
      hash = "sha256-Vl5Emw3O3Ba2hD1GCWune4PGduDDPO0gM5u+zx/OwKo=";
    })
    (fetchpatch {
      name = "43_CVE-2025-0690.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=dad8f502974ed9ad0a70ae6820d17b4b142558fc";
      hash = "sha256-DeWOncndX2VM8w1lb5fd5wHAZrI+ChB5Pj9XbUIfDWY=";
    })
    (fetchpatch {
      name = "44_commands_test_stack_overflow_due_to_unlimited_recursion_depth.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=c68b7d23628a19da67ebe2e06f84165ee04961af";
      hash = "sha256-aputM9KqkB/cK8hBiU9VXbu0LpLNlNCMVIeE9h2pMgY=";
    })
    (fetchpatch {
      name = "45_CVE-2025-1118.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=34824806ac6302f91e8cabaa41308eaced25725f";
      hash = "sha256-PKQs+fCwj4a9p4hbMqAT3tFNoAOw4xnbKmCwjPUgEOc=";
    })
    (fetchpatch {
      name = "46_commands_memrw_disable_memory_reading_in_lockdown_mode.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=340e4d058f584534f4b90b7dbea2b64a9f8c418c";
      hash = "sha256-NiMIUnfRreDBw+k4yxUzoRNMFL8pkJhVtkINVgmv5XA=";
    })
    (fetchpatch {
      name = "47_commands_hexdump_disable_memory_reading_in_lockdown_mode.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=5f31164aed51f498957cdd6ed733ec71a8592c99";
      hash = "sha256-NA7QjxZ9FP+WwiOveqLkbZqsF7hULIyaVS3gNaSUXJE=";
    })
    (fetchpatch {
      name = "48_CVE-2024-45778_CVE-2024-45779.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=26db6605036bd9e5b16d9068a8cc75be63b8b630";
      hash = "sha256-1+ImwkF/qsejWs2lpyO6xbcqVo2NJGv32gjrP8mEPnI=";
    })
    (fetchpatch {
      name = "49_CVE-2025-0677_CVE-2025-0684_CVE-2025-0685_CVE-2025-0686_CVE-2025-0689.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=c4bc55da28543d2522a939ba4ee0acde45f2fa74";
      hash = "sha256-qrlErSImMX8eXJHkXjOe5GZ6lWOya5SVpNoiqyEM1lE=";
    })
    (fetchpatch {
      name = "50_disk_use_safe_math_macros_to_prevent_overflows.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=c407724dad6c3e2fc1571e57adbda71cc03f82aa";
      hash = "sha256-kkAjxXvCdzwqh+oWtEF3qSPiUX9cGWO6eSFVeo7WJzQ=";
    })
    (fetchpatch {
      name = "51_disk_prevent_overflows_when_allocating_memory_for_arrays.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=d8151f98331ee4d15fcca59edffa59246d8fc15f";
      hash = "sha256-2U+gMLigOCCg3P1GB615xQ0B9PDA6j92tt1ba3Tqg+E=";
    })
    (fetchpatch {
      name = "52_disk_check_if_returned_pointer_for_allocated_memory_is_NULL.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=33bd6b5ac5c77b346769ab5284262f94e695e464";
      hash = "sha256-+BaJRskWP/YVEdvIxMvEydjQx2LpLlGphRtZjiOUxJ0=";
    })
    (fetchpatch {
      name = "53_disk_ieee1275_ofdisk_call_grub_ieee1275_close_when_grub_malloc_fails.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=fbaddcca541805c333f0fc792b82772594e73753";
      hash = "sha256-9sGA41HlB/8rtT/fMfkDo4ZJMXBSr+EyN92l/0gDfl4=";
    })
    (fetchpatch {
      name = "54_fs_use_safe_math_macros_to_prevent_overflows.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=6608163b08a7a8be4b0ab2a5cd4593bba07fe2b7";
      excludes = [ "grub-core/fs/erofs.c" ]; # Does not exist on 2.12
      hash = "sha256-mW4MH5VH5pDxCaFhNh/4mEcYloga56p8vCi7X4kSaek=";
    })
    (fetchpatch {
      name = "55_CVE-2025-0678_CVE-2025-1125.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=84bc0a9a68835952ae69165c11709811dae7634e";
      hash = "sha256-rCliqM2+k7rTGNpdHFkg3pHvuISjoG0MQr6/8lIvwK4=";
    })
    (fetchpatch {
      name = "56_fs_prevent_overflows_when_assigning_returned_values_from_read_number.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=cde9f7f338f8f5771777f0e7dfc423ddf952ad31";
      hash = "sha256-dN3HJXNIYtaUZL0LhLabC4VKK6CVC8km9UTw/ln/6ys=";
    })
    (fetchpatch {
      name = "57_fs_zfs_use_safe_math_macros_to_prevent_overflows.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=88e491a0f744c6b19b6d4caa300a576ba56db7c9";
      hash = "sha256-taSuKyCf9+TiQZcF26yMWpDDQqCfTdRuZTqB9aEz3aA=";
    })
    (fetchpatch {
      name = "58_fs_zfs_prevent_overflows_when_allocating_memory_for_arrays.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=7f38e32c7ebeaebb79e2c71e3c7d5ea367d3a39c";
      hash = "sha256-E5VmP7I4TAEXxTz3j7mi/uIr9kOSzMoPHAYAbyu56Xk=";
    })
    (fetchpatch {
      name = "59_fs_zfs_check_if_returned_pointer_for_allocated_memory_is_NULL.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=13065f69dae0eeb60813809026de5bd021051892";
      hash = "sha256-1W//rHUspDS+utdNc069J8lX1ONfoBKiJYnUt46C/D0=";
    })
    (fetchpatch {
      name = "60_fs_zfs_add_missing_NULL_check_after_grub_strdup_call.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=dd6a4c8d10e02ca5056681e75795041a343636e4";
      hash = "sha256-iFLEkz5G6aQ8FXGuY7/wgN4d4o0+sUxWMKYIFcQ/H+o=";
    })
    (fetchpatch {
      name = "61_net_use_safe_math_macros_to_prevent_overflows.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=4beeff8a31c4fb4071d2225533cfa316b5a58391";
      hash = "sha256-/gs5ZhplQ1h7PWw0p+b5+0OxmRcvDRKWHj39ezhivcg=";
    })
    (fetchpatch {
      name = "62_net_prevent_overflows_when_allocating_memory_for_arrays.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=dee2c14fd66bc497cdc74c69fde8c9b84637c8eb";
      hash = "sha256-cO02tCGEeQhQF0TmgtNOgUwRLnNgmxhEefo1gtSlFOk=";
    })
    (fetchpatch {
      name = "63_net_check_if_returned_pointer_for_allocated_memory_is_NULL.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=1c06ec900591d1fab6fbacf80dc010541d0a5ec8";
      hash = "sha256-oSRhWWVraitoVDqGlFOVzdCkaNqFGOHLjJu75CSc388=";
    })
    (fetchpatch {
      name = "64_fs_sfs_check_if_allocated_memory_is_NULL.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=e3c578a56f9294e286b6028ca7c1def997a17b15";
      hash = "sha256-7tvFbmjWmWmmRykQjMvZV6IYlhSS8oNR7YfaO5XXAfU=";
    })
    (fetchpatch {
      name = "65_script_execute_fix_potential_underflow_and_NULL.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=d13b6e8ebd10b4eb16698a002aa40258cf6e6f0e";
      hash = "sha256-paMWaAIImzxtufUrVF5v4T4KnlDAJIPhdaHznu5CyZ8=";
    })
    (fetchpatch {
      name = "66_osdep_unix_getroot_fix_potential_underflow.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=66733f7c7dae889861ea3ef3ec0710811486019e";
      hash = "sha256-/14HC1kcW7Sy9WfJQFfC+YnvS/GNTMP+Uy6Dxd3zkwc=";
    })
    (fetchpatch {
      name = "67_misc_ensure_consistent_overflow_error_messages.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=f8795cde217e21539c2f236bcbb1a4bf521086b3";
      hash = "sha256-4X7wr1Tg16xDE9FO6NTlgkfLV5zFKmajeaOspIqcCuI=";
    })
    (fetchpatch {
      name = "68_bus_usb_ehci_define_GRUB_EHCI_TOGGLE_as_grub_uint32_t.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=9907d9c2723304b42cf6da74f1cc6c4601391956";
      hash = "sha256-D8xaI8g7ffGGmZqqeS8wxWIFLUWUBfmHwMVOHkYTc2I=";
    })
    (fetchpatch {
      name = "69_normal_menu_use_safe_math_to_avoid_an_integer_overflow.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=5b36a5210e21bee2624f8acc36aefd8f10266adb";
      hash = "sha256-UourmM0Zlaj4o+SnYi5AtjfNujDOt+2ez2XH/uWyiaM=";
    })
    (fetchpatch {
      name = "70_kern_partition_add_sanity_check_after_grub_strtoul_call.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=8e6e87e7923ca2ae880021cb42a35cc9bb4c8fe2";
      hash = "sha256-4keMUu6ZDKmuSQlFnldV15dDGUibsnSvoEWhLsqWieI=";
    })
    (fetchpatch {
      name = "71_kern_misc_add_sanity_check_after_grub_strtoul_call.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=a8d6b06331a75d75b46f3dd6cc6fcd40dcf604b7";
      hash = "sha256-2Mpe1sqyuoUPyMAKGZTNzG/ig3G3K8w0gia7lc508Rg=";
    })
    (fetchpatch {
      name = "72_loader_i386_linux_cast_left_shift_to_grub_uint32_t.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=490a6ab71cebd96fae7a1ceb9067484f5ccbec2a";
      hash = "sha256-e49OC1EBaX0/nWTTXT5xE5apTJPQV0myP5Ohxn9Wwa8=";
    })
    (fetchpatch {
      name = "73_loader_i386_bsd_use_safe_math_to_avoid_underflow.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=4dc6166571645780c459dde2cdc1b001a5ec844c";
      hash = "sha256-e8X+oBvejcFNOY1Tp/f6QqCDwrgK7f9u1F8SdO/dhy4=";
    })
    (fetchpatch {
      # Fixes 7e2f750f0a (security patch 14/73)
      name = "fs_ext2_rework_out-of-bounds_read_for_inline_and_external_extents.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=348cd416a3574348f4255bf2b04ec95938990997";
      hash = "sha256-WBLYQxv8si2tvdPAvbm0/4NNqYWBMJpFV4GC0HhN/kE=";
    })
    (fetchpatch {
      name = "CVE-2025-4382.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=c448f511e74cb7c776b314fcb7943f98d3f22b6d";
      hash = "sha256-64gMhCEW0aYHt46crX/qN/3Hj8MgvWLazgQlVXqe8LE=";
    })
    # https://lists.gnu.org/archive/html/grub-devel/2025-11/msg00155.html
    (fetchpatch {
      name = "1_commands_test_fix_error_in_recursion_depth_calculation.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=cc9d621dd06bfa12eac511b37b4ceda5bd2f8246";
      hash = "sha256-GpLpqTKr2ke/YaxnZIO1Kh9wpde44h2mvwcODcAL/nk=";
    })
    (fetchpatch {
      name = "2_CVE-2025-54771.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=c4fb4cbc941981894a00ba8e75d634a41967a27f";
      hash = "sha256-yWowlAMVXdfIyC+BiB00IZvTwIybvaPhxAyz0MPjQuY=";
    })
    (fetchpatch {
      name = "3_CVE-2025-54770.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=10e58a14db20e17d1b6a39abe38df01fef98e29d";
      hash = "sha256-1ROc5n7sApw7aGr+y8gygFqVkifLdgOD3RPaW9b8aQQ=";
    })
    (fetchpatch {
      name = "4_CVE-2025-61662.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=8ed78fd9f0852ab218cc1f991c38e5a229e43807";
      hash = "sha256-mG+vcZHbF4duY2YoYAzPBQRHfWvp5Fvgtm0XBk7JqqM=";
    })
    (fetchpatch {
      name = "5_CVE-2025-61663_CVE-2025-61664.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=05d3698b8b03eccc49e53491bbd75dba15f40917";
      hash = "sha256-kgtXhZmAQpassEf8+RzqkghAzLrCcRoRMMnfunF/0J8=";
    })
    (fetchpatch {
      name = "6_tests_lib_functional_test_unregister_commands_on_module_unload.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=9df1e693e70c5a274b6d60dc76efe2694b89c2fc";
      hash = "sha256-UzyYkpP7vivx2jzxi7BMP9h9OB2yraswrMW4g9UWsbI=";
    })
    (fetchpatch {
      name = "7_CVE-2025-61661.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=549a9cc372fd0b96a4ccdfad0e12140476cc62a3";
      hash = "sha256-2mlDoVXY7Upwx4QBeAMOHUtoUlyx1MDDmabnrwK1gEY=";
    })
    (fetchpatch {
      name = "8_commands_usbtest_ensure_string_length_is_sufficient_in_usb_string_processing.patch";
      url = "https://git.savannah.gnu.org/cgit/grub.git/patch/?id=7debdce1e98907e65223a4b4c53a41345ac45e53";
      hash = "sha256-2ALvrmwxvpjQYjGNrQ0gyGotpk0kgmYlJXMF1xXrnEw=";
    })
  ];

  postPatch =
    if kbdcompSupport then
      ''
        sed -i util/grub-kbdcomp.in -e 's@\bckbcomp\b@${ckbcomp}/bin/ckbcomp@'
      ''
    else
      ''
        echo '#! ${runtimeShell}' > util/grub-kbdcomp.in
        echo 'echo "Compile grub2 with { kbdcompSupport = true; } to enable support for this command."' >> util/grub-kbdcomp.in
      '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    bison
    flex
    python3
    pkg-config
    gettext
    freetype
    autoconf
    automake
    help2man
  ];
  buildInputs = [
    ncurses
    libusb-compat-0_1
    freetype
    lvm2
    fuse
    libtool
    bash
  ]
  ++ lib.optional doCheck qemu
  ++ lib.optional zfsSupport zfs;

  strictDeps = true;

  hardeningDisable = [ "all" ];

  separateDebugInfo = !xenSupport;

  preConfigure = ''
     for i in "tests/util/"*.in
     do
       sed -i "$i" -e's|/bin/bash|${stdenv.shell}|g'
     done

     # Apparently, the QEMU executable is no longer called
     # `qemu-system-i386', even on i386.
     #
     # In addition, use `-nodefaults' to avoid errors like:
     #
     #  chardev: opening backend "stdio" failed
     #  qemu: could not open serial device 'stdio': Invalid argument
     #
     # See <http://www.mail-archive.com/qemu-devel@nongnu.org/msg22775.html>.
     sed -i "tests/util/grub-shell.in" \
         -e's/qemu-system-i386/qemu-system-x86_64 -nodefaults/g'

    unset CPP # setting CPP intereferes with dependency calculation

    patchShebangs .

    GNULIB_REVISION=$(. bootstrap.conf; echo $GNULIB_REVISION)
    if [ "$GNULIB_REVISION" != ${gnulib.rev} ]; then
      echo "This version of GRUB requires a different gnulib revision!"
      echo "We have: ${gnulib.rev}"
      echo "GRUB needs: $GNULIB_REVISION"
      exit 1
    fi

    cp -f --no-preserve=mode ${locales}/po/LINGUAS ${locales}/po/*.po po

    ./bootstrap --no-git --gnulib-srcdir=${gnulib}

    substituteInPlace ./configure --replace '/usr/share/fonts/unifont' '${unifont}/share/fonts'
  '';

  postConfigure = ''
    # make sure .po files are up to date to workaround
    # parallel `msgmerge --update` on autogenerated .po files:
    #   https://github.com/NixOS/nixpkgs/pull/248747#issuecomment-1676301670
    make dist
  '';

  configureFlags = [
    "--enable-grub-mount" # dep of os-prober
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # grub doesn't do cross-compilation as usual and tries to use unprefixed
    # tools to target the host. Provide toolchain information explicitly for
    # cross builds.
    #
    # Ref: # https://github.com/buildroot/buildroot/blob/master/boot/grub2/grub2.mk#L108
    "TARGET_CC=${stdenv.cc.targetPrefix}cc"
    "TARGET_NM=${stdenv.cc.targetPrefix}nm"
    "TARGET_OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
    "TARGET_RANLIB=${stdenv.cc.targetPrefix}ranlib"
    "TARGET_STRIP=${stdenv.cc.targetPrefix}strip"
  ]
  ++ lib.optional zfsSupport "--enable-libzfs"
  ++ lib.optionals efiSupport [
    "--with-platform=efi"
    "--target=${efiSystemsBuild.${stdenv.hostPlatform.system}.target}"
    "--program-prefix="
  ]
  ++ lib.optionals xenSupport [
    "--with-platform=xen"
    "--target=${xenSystemsBuild.${stdenv.hostPlatform.system}.target}"
  ]
  ++ lib.optionals xenPvhSupport [
    "--with-platform=xen_pvh"
    "--target=${xenPvhSystemsBuild.${stdenv.hostPlatform.system}.target}"
  ];

  # save target that grub is compiled for
  grubTarget =
    if efiSupport then
      "${efiSystemsInstall.${stdenv.hostPlatform.system}.target}-efi"
    else
      lib.optionalString inPCSystems "${pcSystems.${stdenv.hostPlatform.system}.target}-pc";

  doCheck = false;
  enableParallelBuilding = true;

  postInstall = ''
    # Avoid a runtime reference to gcc
    sed -i $out/lib/grub/*/modinfo.sh -e "/grub_target_cppflags=/ s|'.*'|' '|"
    # just adding bash to buildInputs wasn't enough to fix the shebang
    substituteInPlace $out/lib/grub/*/modinfo.sh \
      --replace ${buildPackages.bash} "/usr/bin/bash"
  '';

  passthru.tests = {
    nixos-grub = nixosTests.grub;
    nixos-install-simple = nixosTests.installer.simple;
    nixos-install-grub-uefi = nixosTests.installer.simpleUefiGrub;
    nixos-install-grub-uefi-spec = nixosTests.installer.simpleUefiGrubSpecialisation;
  };

  meta = with lib; {
    description = "GNU GRUB, the Grand Unified Boot Loader";

    longDescription = ''
      GNU GRUB is a Multiboot boot loader. It was derived from GRUB, GRand
      Unified Bootloader, which was originally designed and implemented by
      Erich Stefan Boleyn.

      Briefly, the boot loader is the first software program that runs when a
      computer starts.  It is responsible for loading and transferring
      control to the operating system kernel software (such as the Hurd or
      the Linux).  The kernel, in turn, initializes the rest of the
      operating system (e.g., GNU).
    '';

    homepage = "https://www.gnu.org/software/grub/";

    license = licenses.gpl3Plus;

    platforms =
      if efiSupport then
        lib.attrNames efiSystemsBuild
      else if xenSupport then
        lib.attrNames xenSystemsBuild
      else if xenPvhSupport then
        lib.attrNames xenPvhSystemsBuild
      else
        platforms.gnu ++ platforms.linux;

    maintainers = [ ];
  };
}
