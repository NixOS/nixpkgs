{
  fetchDebianPatch,
  fetchFromGitHub,
  lib,
  makeWrapper,
  manubulon-snmp-plugins,
  nix-update-script,
  perlPackages,
  stdenv,
  testers,
}:
stdenv.mkDerivation rec {
  pname = "manubulon-snmp-plugins";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "SteScho";
    repo = "manubulon-snmp";
    rev = "v${version}";
    sha256 = "sha256-I4wKAy704ddoseb7NFBj7+O7l1Sy2JItoe6wrBUaJRQ=";
  };

  patches = [
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "10_check_snmp_storage_error_handling";
      hash = "sha256-P8srMAAcYiSJYww7eBRN78aCSQPq2+fqOJqJ187l2u8=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "11_check_snmp_int_agent_workaround";
      hash = "sha256-BXC9QwB/3ztpJCTBZqeCfTZYY5DPwyPJjy62KQqiEcQ=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "12_check_snmp_mem_perf";
      hash = "sha256-cAH/Oj/r35xMKn56w3jXOtoCx1Wfe2YWTCOS6PFkiTQ=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "13_check_snmp_process_new_features";
      hash = "sha256-nqZEy4UFtz3o6taJ7zNhHWjQXtsavEdVuhdUH6kfLSM=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "14_check_snmp_int_ign";
      hash = "sha256-ODOsLu7avqmEmmt6EC4ZlPn6bXeEqVvaUZxOpFnzx98=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "15_check_snmp_int_spaces";
      hash = "sha256-WvA0/DasyMXJgkNhNQNFYatZ4rT32ybbreomIE2z0vc=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "16_check_snmp_win_max_message_size";
      hash = "sha256-f28TokPhukMqmNRSpA0ebMHPHYO6Xnq7ABTb19dNtw0=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "17_check_snmp_storage_okifempty";
      hash = "sha256-OZ+0y65rDekD3G21vXmJsWltMyfx2+vQ8wUGdLgd2D0=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "18_check_snmp_int_fix_perf_out";
      hash = "sha256-1jsDCTCUqYPIJNzlWMVJeUHEZ5tB/NhNex2oLv8dc5U=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      patch = "19_check_snmp_int_remove_unneeded_my";
      debianRevision = "4";
      hash = "sha256-C3Bh94aRRq94kg94un3rEaCb5W7z3gNiD4n8FFel9fk=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      patch = "20_check_snmp_int_avaid_huge_amount_of_regex";
      debianRevision = "4";
      hash = "sha256-Kh3hk7xZNWHmYlDM4k6QTFdetklspsBVvIl2S9SO6AA=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "21_check_snmp_load_update_fortiswitch_and_fortigate4.3";
      hash = "sha256-D6q1ZZ0tMHcvIu8EWyx4A5w+5Tzj68JK30kL7fm679A=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "22_check_snmp_storage_fix_space_btrfs";
      hash = "sha256-fqq1UUmqzYdxEpcrelGxrhqRghaH7BWAueTBmr8czW0=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "23_check_snmp_int_interface_speed";
      hash = "sha256-dn5yzqsSfwpVimxzBKIEhX64RR0C29ORiv3F+uKUIk8=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "24_tcp_udp_ipv4_ipv6";
      hash = "sha256-W5bEGqX2bAT4t0jey6p9TBT28ckiLPxPZWcajjyI/xU=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "25_check_snmp_int_add_metrik";
      hash = "sha256-5IlnjOAb9e2SscG5fBQ7hfJXAOwZtKOGWnPuQigXrUo=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "50_disable_epn";
      hash = "sha256-Qsf/4JeLV2P+XUnHDCH6QYaRL7bdFJQSEdhpkfsZTgw=";
      pname = "nagios-snmp-plugins";
    })
    (fetchDebianPatch {
      inherit version;
      debianRevision = "4";
      patch = "51_fix_privacy_doc";
      hash = "sha256-ZIYrNCZSTWSfgcR+Oe5Nuap/az3DjuD+Uil05RtXE+M=";
      pname = "nagios-snmp-plugins";
    })
  ];

  buildInputs = with perlPackages; [
    CryptDES
    CryptRijndael
    DigestHMAC
    DigestSHA1
    GetoptLongDescriptive
    NetSNMP
    perl
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir --parents $out/bin
    install --mode=0755 plugins/*.pl $out/bin
    runHook postInstall
  '';

  postFixup = ''
    for f in $out/bin/* ; do
      wrapProgram $f --set PERL5LIB $PERL5LIB --set LC_ALL C
    done
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = manubulon-snmp-plugins;
      # Program returns status code 3
      command = "check_snmp_int.pl --version || true";
      version = "check_snmp_int version : ${version}";
    };
  };

  meta = with lib; {
    changelog = "https://github.com/SteScho/manubulon-snmp/releases/tag/v${version}";
    description = "Set of Icinga/Nagios plugins to check hosts and hardware with the SNMP protocol";
    homepage = "https://github.com/SteScho/manubulon-snmp";
    license = with licenses; [ gpl2Only ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ jwillikers ];
  };
}
