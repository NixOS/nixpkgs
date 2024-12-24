{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "arj";
  version = "3.10.22";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1nx7jqxwqkihhdmdbahhzqhjqshzw1jcsvwddmxrwrn8rjdlr7jq";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/001_arches_align.patch";
      sha256 = "0i3qclm2mh98c04rqpx1r4qagd3wpxlkj7lvq0ddpkmr8bm0fh0m";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/002_no_remove_static_const.patch";
      sha256 = "0zfjqmjsj0y1kfzxbp29v6nxq5qwgazhb9clqc544sm5zn0bdp8n";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/003_64_bit_clean.patch";
      sha256 = "0mda9fkaqf2s1xl6vlbkbq20362h3is9dpml9kfmacpbifl4dx3n";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/004_parallel_build.patch";
      sha256 = "0gam6k7jknzmbjlf1r6c9kjh5s5h76pd31v59cnaqiycwiy8z6q9";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/005_use_system_strnlen.patch";
      sha256 = "0q0ypm8mdsxd0rl1k0id6fdx5m7mvqgwcla4r250cmc6zqzpib6d";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/006_use_safe_strcpy.patch";
      sha256 = "1garad95s34cix3kd77lz37andrcnz19glzkfdnkjaq7ldvzwikc";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/hurd_no_fcntl_getlk.patch";
      sha256 = "0b3hpn4qypimrw9ar2n4h24886sl6pmim4lb4ly1wqcq0f73arva";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/security_format.patch";
      sha256 = "0q67cvln55p38bm0xwd2cgppqmkp2nfar2pg1zj78f7ncn35lbvf";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/doc_refer_robert_k_jung.patch";
      sha256 = "1wxdx0m6a9vdvjlaycwsissn75l1ni7grg8n6qmkynz2vrcvgzb1";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/gnu_build_fix.patch";
      sha256 = "19ycp1rak7l6ql28m50v95ls621w3sl8agw5r5va73svkgh8hc3g";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/gnu_build_flags.patch";
      sha256 = "1jw1y9i9lw1idgi4l9cycwsql1hcz1m4f3k2iybwsgx0acaw695q";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/gnu_build_strip.patch";
      sha256 = "1b18khj6cxnjyqk2ycygwqlcs20hrsbf4h6bckl99dxnpbq5blxi";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/gnu_build_pie.patch";
      sha256 = "1jqswxgc1plipblf055n9175fbanfi6fb67lnzk8dcvxjn227fs3";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/self_integrity_64bit.patch";
      sha256 = "0s5zdq81a0f83hdg9hy6lqn3xvckx9y9r20awczm9mbf11vi01cb";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/security-afl.patch";
      sha256 = "0yajcwpghij8wg21a0kkp3f9x7anz5m121jx2vnkyn04bvi9541a";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/security-traversal-dir.patch";
      sha256 = "10lv3867k0wm2s0cyf40hkxfqbjaxm4aph5ivk2q2rjkracrn2y4";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/security-traversal-symlink.patch";
      sha256 = "095pdfskxwh0jnyy31dpz10s2ppv8n7lvvn4q722y3g71d0c79qq";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/out-of-bounds-read.patch";
      sha256 = "0ps9lqkbqzlhzr2bnr47sir431z1nywr7nagkmk42iki4d96v0jq";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/remove_build_date.patch";
      sha256 = "1vjlfq6firxpj068l9acyqs77mfydn1rwgr2jmxgsy9mq0fw1dsc";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/reproducible_help_archive.patch";
      sha256 = "0l3qi9f140pwc6fk8qdbxx4g9d8zlf45asimmr8wfpbi4pf59n8i";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/gnu_build_cross.patch";
      sha256 = "1vb0vbh3jbxj192q47vg3f41l343ghcz2ypbrrm2bkbpwm5cl8qr";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/fix-time_t-usage.patch";
      sha256 = "012c6pnf5y4jwn715kxn3vjy088rm905959j6yh8bslyx84qaijv";
    })

    (fetchpatch {
      url = "https://sources.debian.org/data/main/a/arj/3.10.22-24/debian/patches/gnu_build_fix_autoreconf.patch";
      sha256 = "0yhxbdasnbqcg1nyx2379fpbr7fmdlv4n2nlxrv1z1vbc7rlvw9d";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace environ.c \
        --replace "  #include <sys/statfs.h>" "  #include <sys/mount.h>"
  '';

  preAutoreconf = ''
    cd gnu
  '';

  postConfigure = ''
    cd ..
  '';

  meta = with lib; {
    description = "Open-source implementation of the world-famous ARJ archiver";
    longDescription = ''
      This version of ARJ has been created with an intent to preserve maximum
      compatibility and retain the feature set of the original ARJ archiver as
      provided by ARJ Software, Inc.
    '';
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.sander ];
    platforms = platforms.unix;
  };
}
