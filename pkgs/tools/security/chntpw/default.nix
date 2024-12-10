{
  lib,
  stdenv,
  fetchurl,
  unzip,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "chntpw";

  version = "140201";

  src = fetchurl {
    url = "http://pogostick.net/~pnh/ntpasswd/chntpw-source-${version}.zip";
    sha256 = "1k1cxsj0221dpsqi5yibq2hr7n8xywnicl8yyaicn91y8h2hkqln";
  };

  nativeBuildInputs = [ unzip ];

  patches = [
    ./00-chntpw-build-arch-autodetect.patch
    ./01-chntpw-install-target.patch
    # Import various bug fixes from debian
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/chntpw/140201-1/debian/patches/04_get_abs_path";
      sha256 = "17h0gaczqd5b792481synr1ny72frwslb779lm417pyrz6kh9q8n";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/chntpw/140201-1/debian/patches/06_correct_test_open_syscall";
      sha256 = "00lg83bimbki988n71w54mmhjp9529r0ngm40d7fdmnc2dlpj3hd";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/chntpw/140201-1/debian/patches/07_detect_failure_to_write_key";
      sha256 = "0pk6xnprh2pqyx4n4lw3836z6fqsw3mclkzppl5rhjaahriwxw4l";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/chntpw/140201-1/debian/patches/08_no_deref_null";
      sha256 = "1g7pfmjaj0c2sm64s3api2kglj7jbgddjjd3r4drw6phwdkah0zs";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/chntpw/140201-1/debian/patches/09_improve_robustness";
      sha256 = "1nszkdy01ixnain7cwdmfbhjngphw1300ifagc1wgl9wvghzviaa";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/chntpw/140201-1/debian/patches/11_improve_documentation";
      sha256 = "0yql6hj72q7cq69rrspsjkpiipdhcwb0b9w5j8nhq40cnx9mgqgg";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/chntpw/140201-1/debian/patches/12_readonly_filesystem";
      sha256 = "1kxcy7f2pl6fqgmjg8bnl3pl5wgiw5xnbyx12arinmqkkggp4fa4";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/chntpw/140201-1/debian/patches/13_write_to_hive";
      sha256 = "1638lcyxjkrkmbr3n28byixny0qrxvkciw1xd97x48mj6bnwqrkv";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/chntpw/140201-1/debian/patches/14_improve_description";
      sha256 = "11y5kc4dh4zv24nkb0jw2zwlifx6nzsd4jbizn63l6dbpqgb25rs";
    })
  ];

  installPhase = ''
    make install PREFIX=$out
  '';

  meta = with lib; {
    homepage = "http://pogostick.net/~pnh/ntpasswd/";
    description = "An utility to reset the password of any user that has a valid local account on a Windows system";
    maintainers = with lib.maintainers; [ deepfire ];
    license = licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
