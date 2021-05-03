{ stdenv, lib, fetchurl, fetchsvn,
  jansson, libedit, libxml2, libxslt, ncurses, openssl, sqlite,
  utillinux, dmidecode, libuuid, newt,
  lua, speex,
  srtp, wget, curl, iksemel, pkgconfig
}:

let
  common = {version, sha256, externals}: stdenv.mkDerivation {
    inherit version;
    pname = "asterisk";

    buildInputs = [ jansson libedit libxml2 libxslt ncurses openssl sqlite
                    dmidecode libuuid newt
                    lua speex
                    srtp wget curl iksemel ];
    nativeBuildInputs = [ utillinux pkgconfig ];

    patches = [
      # We want the Makefile to install the default /var skeleton
      # under ${out}/var but we also want to use /var at runtime.
      # This patch changes the runtime behavior to look for state
      # directories in /var rather than ${out}/var.
      ./runtime-vardirs.patch
    ];

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
    '';

    configureFlags = [
      "--libdir=\${out}/lib"
      "--with-lua=${lua}/lib"
      "--with-pjproject-bundled"
      "--with-externals-cache=$(PWD)/externals_cache"
    ];

    preBuild = ''
      make menuselect.makeopts
      ${lib.optionalString (externals ? "addons/mp3") ''
        substituteInPlace menuselect.makeopts --replace 'format_mp3 ' ""
      ''}
    '';

    postInstall = ''
      # Install sample configuration files for this version of Asterisk
      make samples
      ${lib.optionalString (lib.versionAtLeast version "17.0.0") "make install-headers"}
    '';

    meta = with stdenv.lib; {
      description = "Software implementation of a telephone private branch exchange (PBX)";
      homepage = "https://www.asterisk.org/";
      license = licenses.gpl2Only;
      maintainers = with maintainers; [ auntie DerTim1 yorickvp ];
    };
  };

  pjproject_2_10 = fetchurl {
    url = "https://raw.githubusercontent.com/asterisk/third-party/master/pjproject/2.10/pjproject-2.10.tar.bz2";
    sha256 = "14qmddinm4bv51rl0wwg5133r64x5bd6inwbx27ahb2n0151m2if";
  };

  mp3-202 = fetchsvn {
    url = "http://svn.digium.com/svn/thirdparty/mp3/trunk";
    rev = "202";
    sha256 = "1s9idx2miwk178sa731ig9r4fzx4gy1q8xazfqyd7q4lfd70s1cy";
  };

in rec {
  # Supported releases (as of 2020-10-07).
  # Source: https://wiki.asterisk.org/wiki/display/AST/Asterisk+Versions
  # Exact version can be found at https://www.asterisk.org/downloads/asterisk/all-asterisk-versions/
  #
  # Series  Type       Rel. Date   Sec. Fixes  EOL
  # 13.x    LTS        2014-10-24  2020-10-24  2021-10-24
  # 16.x    LTS        2018-10-09  2022-10-09  2023-10-09
  asterisk-lts = asterisk_16;
  # 17.x    Standard   2019-10-28  2020-10-28  2021-10-28
  asterisk-stable = asterisk_17;
  asterisk = asterisk_17;

  asterisk_13 = common {
    version = "13.38.2";
    sha256 = "1v7wgsa9vf7qycg3xpvmn2bkandkfh3x15pr8ylg0w0gvfkkf5b9";
    externals = {
      "externals_cache/pjproject-2.10.tar.bz2" = pjproject_2_10;
      "addons/mp3" = mp3-202;
    };
  };

  asterisk_16 = common {
    version = "16.17.0";
    sha256 = "1bzlsk9k735qf8a693b6sa548my7m9ahavmdicwmc14px70wrvnw";
    externals = {
      "externals_cache/pjproject-2.10.tar.bz2" = pjproject_2_10;
      "addons/mp3" = mp3-202;
    };
  };

  asterisk_17 = common {
    version = "17.9.3";
    sha256 = "0nhk0izrxx24pz806fwnhidjmciwrkcrsvxvhrdvibiqyvfk8yk7";
    externals = {
      "externals_cache/pjproject-2.10.tar.bz2" = pjproject_2_10;
      "addons/mp3" = mp3-202;
    };
  };
}
