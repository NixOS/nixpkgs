{ stdenv
, lib
, fetchurl
, fetchsvn
, fetchFromGitHub
, jansson
, libedit
, libxml2
, libxslt
, ncurses
, openssl
, sqlite
, util-linux
, dmidecode
, libuuid
, newt
, lua
, speex
, libopus
, opusfile
, libogg
, srtp
, wget
, curl
, iksemel
, pkg-config
, autoconf
, libtool
, automake
, fetchpatch
, python39
, writeScript
, withOpus ? true
, ldapSupport ? false
, openldap
}:

let
  # remove when upgrading to pjsip >2.13
  pjsip_2_13_patches = [
    (fetchpatch {
      name = "CVE-2022-23537.patch";
      url = "https://github.com/pjsip/pjproject/commit/d8440f4d711a654b511f50f79c0445b26f9dd1e1.patch";
      sha256 = "sha256-7ueQCHIiJ7MLaWtR4+GmBc/oKaP+jmEajVnEYqiwLRA=";
    })
    (fetchpatch {
      name = "CVE-2022-23547.patch";
      url = "https://github.com/pjsip/pjproject/commit/bc4812d31a67d5e2f973fbfaf950d6118226cf36.patch";
      sha256 = "sha256-bpc8e8VAQpfyl5PX96G++6fzkFpw3Or1PJKNPKl7N5k=";
    })
  ];

  common = { version, sha256, externals, pjsip_patches ? [ ] }: stdenv.mkDerivation {
    inherit version;
    pname = "asterisk"
      + lib.optionalString ldapSupport "-ldap";


    buildInputs = [
      jansson
      libedit
      libxml2
      libxslt
      ncurses
      openssl
      sqlite
      dmidecode
      libuuid
      newt
      lua
      speex
      srtp
      wget
      curl
      iksemel
    ]
    ++ lib.optionals withOpus [ libopus opusfile libogg ]
    ++ lib.optionals ldapSupport [ openldap ];
    nativeBuildInputs = [ util-linux pkg-config autoconf libtool automake ];

    patches = [
      # We want the Makefile to install the default /var skeleton
      # under ${out}/var but we also want to use /var at runtime.
      # This patch changes the runtime behavior to look for state
      # directories in /var rather than ${out}/var.
      ./runtime-vardirs.patch
    ] ++ lib.optional withOpus "${asterisk-opus}/asterisk.patch";

    postPatch = ''
      echo "PJPROJECT_CONFIG_OPTS += --prefix=$out" >> third-party/pjproject/Makefile.rules
    '';

    src = fetchurl {
      url = "https://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-${version}.tar.gz";
      inherit sha256;
    };

    # The default libdir is $PREFIX/usr/lib, which causes problems when paths
    # compiled into Asterisk expect ${out}/usr/lib rather than ${out}/lib.

    # Copy in externals to avoid them being downloaded;
    # they have to be copied, because the modification date is checked.
    # If you are getting a permission denied error on this dir,
    # you're likely missing an automatically downloaded dependency
    preConfigure = ''
      mkdir externals_cache

      ${lib.concatStringsSep "\n"
        (lib.mapAttrsToList (dst: src: "cp -r --no-preserve=mode ${src} ${dst}") externals)}

      ${lib.optionalString (externals ? "addons/mp3") "bash contrib/scripts/get_mp3_source.sh || true"}

      chmod -w externals_cache
      ${lib.optionalString withOpus ''
        cp ${asterisk-opus}/include/asterisk/* ./include/asterisk
        cp ${asterisk-opus}/codecs/* ./codecs
        cp ${asterisk-opus}/formats/* ./formats
      ''}
      ${lib.concatMapStringsSep "\n" (patch: ''
        cp ${patch} ./third-party/pjproject/patches/${patch.name}
      '') pjsip_patches}
      ./bootstrap.sh
    '';

    configureFlags = [
      "--libdir=\${out}/lib"
      "--with-lua=${lua}/lib"
      "--with-pjproject-bundled"
      "--with-externals-cache=$(PWD)/externals_cache"
    ];

    preBuild = ''
      cat third-party/pjproject/source/pjlib-util/src/pjlib-util/scanner.c
      make menuselect.makeopts
      ${lib.optionalString (externals ? "addons/mp3") ''
        substituteInPlace menuselect.makeopts --replace 'format_mp3 ' ""
      ''}
      ${lib.optionalString withOpus ''
        substituteInPlace menuselect.makeopts --replace 'codec_opus_open_source ' ""
        substituteInPlace menuselect.makeopts --replace 'format_ogg_opus_open_source ' ""
      ''}
    '';

    postInstall = ''
      # Install sample configuration files for this version of Asterisk
      make samples
      ${lib.optionalString (lib.versionAtLeast version "17.0.0") "make install-headers"}
    '';

    meta = with lib; {
      description = "Software implementation of a telephone private branch exchange (PBX)";
      homepage = "https://www.asterisk.org/";
      license = licenses.gpl2Only;
      maintainers = with maintainers; [ auntie DerTim1 yorickvp ];
    };
  };

  pjproject_2_13 = fetchurl
    {
      url = "https://raw.githubusercontent.com/asterisk/third-party/master/pjproject/2.13/pjproject-2.13.tar.bz2";
      hash = "sha256-Zj93PUAct13KVR5taOWEbQdKq76wicaBTNHpHC0rICY=";
    } // {
    pjsip_patches = pjsip_2_13_patches;
  };

  mp3-202 = fetchsvn {
    url = "http://svn.digium.com/svn/thirdparty/mp3/trunk";
    rev = "202";
    sha256 = "1s9idx2miwk178sa731ig9r4fzx4gy1q8xazfqyd7q4lfd70s1cy";
  };

  asterisk-opus = fetchFromGitHub {
    owner = "traud";
    repo = "asterisk-opus";
    # No releases, points to master as of 2022-04-06
    rev = "a959f072d3f364be983dd27e6e250b038aaef747";
    sha256 = "sha256-CASlTvTahOg9D5jccF/IN10LP/U8rRy9BFCSaHGQfCw=";
  };

  # auto-generated by update.py
  versions = lib.mapAttrs
    (_: { version, sha256 }:
      let
        pjsip = pjproject_2_13;
      in
      common {
        inherit version sha256;
        inherit (pjsip) pjsip_patches;
        externals = {
          "externals_cache/${pjsip.name}" = pjsip;
          "addons/mp3" = mp3-202;
        };
      })
    (lib.importJSON ./versions.json);

  updateScript_python = python39.withPackages (p: with p; [ packaging beautifulsoup4 requests ]);
  updateScript = writeScript "asterisk-update" ''
    #!/usr/bin/env bash
    exec ${updateScript_python}/bin/python ${toString ./update.py}
  '';

in
{
  # Supported releases (as of 2023-04-19).
  # v16 and v19 have been dropped because they go EOL before the NixOS 23.11 release.
  # Source: https://wiki.asterisk.org/wiki/display/AST/Asterisk+Versions
  # Exact version can be found at https://www.asterisk.org/downloads/asterisk/all-asterisk-versions/
  #
  # Series  Type       Rel. Date   Sec. Fixes  EOL
  # 16.x    LTS        2018-10-09  2022-10-09  2023-10-09 (dropped)
  # 18.x    LTS        2020-10-20  2024-10-20  2025-10-20
  # 19.x    Standard   2021-11-02  2022-11-02  2023-11-02 (dropped)
  # 20.x    LTS        2022-11-02  2026-10-19  2027-10-19
  # 21.x    Standard   2023-10-18  2025-10-18  2026-10-18 (unreleased)
  asterisk-lts = versions.asterisk_18;
  asterisk-stable = versions.asterisk_20;
  asterisk = versions.asterisk_20.overrideAttrs (o: {
    passthru = (o.passthru or { }) // { inherit updateScript; };
  });

} // versions
