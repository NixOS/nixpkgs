{ stdenv, pkgs, lib, fetchurl, fetchgit, fetchsvn, fetchpatch,
  jansson, libxml2, libxslt, ncurses, openssl, sqlite,
  utillinux, dmidecode, libuuid, binutils, newt,
  lua, speex,
  srtp, wget, curl
}:

let
  common = {version, sha256, externals}: stdenv.mkDerivation rec {
    inherit version;
    name = "asterisk-${version}";

    buildInputs = [ jansson libxml2 libxslt ncurses openssl sqlite utillinux dmidecode libuuid binutils newt lua speex srtp wget curl ];

    patches = [
      # We want the Makefile to install the default /var skeleton
      # under ${out}/var but we also want to use /var at runtime.
      # This patch changes the runtime behavior to look for state
      # directories in /var rather than ${out}/var.
      ./runtime-vardirs.patch
      (fetchpatch {
         url = "http://sources.debian.net/data/main/a/asterisk/1:13.14.1~dfsg-1/debian/patches/pjsip_unresolved_symbol.patch";
         sha256 = "0i6a6zplvzbjcvxqlmr87jmrfza7c3qx0rlym2nlmzzp2m7qpnfp";
      })
    ];

    # Disable MD5 verification for pjsip
    postPatch = ''
      sed -i 's|$(verify_tarball)|true|' third-party/pjproject/Makefile
    '';

    src = fetchurl {
      url = "http://downloads.asterisk.org/pub/telephony/asterisk/old-releases/asterisk-${version}.tar.gz";
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
    '' + lib.concatStringsSep "\n"
        (lib.mapAttrsToList (dst: src: "cp -r --no-preserve=mode ${src} ${dst}") externals) + ''

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
      substituteInPlace menuselect.makeopts --replace 'format_mp3 ' ""
    '';

    postInstall = ''
      # Install sample configuration files for this version of Asterisk
      make samples
    '';

    meta = with stdenv.lib; {
      description = "Software implementation of a telephone private branch exchange (PBX)";
      homepage = http://www.asterisk.org/;
      license = licenses.gpl2;
      maintainers = with maintainers; [ auntie DerTim1 yorickvp ];
    };
  };

  pjproject-26 = fetchurl {
    url = http://www.pjsip.org/release/2.6/pjproject-2.6.tar.bz2;
    sha256 = "1d67c58jn22f7h6smkykk5vwl3sqpc7xi2vm3j3lbn3lq6hisnig";
  };

  mp3-202 = fetchsvn {
    url = http://svn.digium.com/svn/thirdparty/mp3/trunk;
    rev = 202;
    sha256 = "1s9idx2miwk178sa731ig9r4fzx4gy1q8xazfqyd7q4lfd70s1cy";
  };

in
{

  asterisk-lts = common {
    version = "13.15.0";
    sha256 = "0i2qzfa1iyh66nma39kdigb9lp5gz3sn46znd2djz24wgmamb2lb";
    externals = {
      "externals_cache/pjproject-2.6.tar.bz2" = pjproject-26;
      "addons/mp3" = mp3-202;
    };
  };

  asterisk-stable = common {
    version = "14.6.0";
    sha256 = "1d3jjdapfv169d8yhfi92j75iwk9726brv1rjjy288d47jn3sm26";
    externals = {
      "externals_cache/pjproject-2.6.tar.bz2" = pjproject-26;
      "addons/mp3" = mp3-202;
    };
  };

  # asterisk-git = common {
  #   version = "15-pre";
  #   sha256 = "...";
  #   externals = {
  #    "externals_cache/pjproject-2.5.5.tar.bz2" = pjproject-255;
      # Note that these sounds are included with the release tarball. They are
      # provided here verbatim for the convenience of anyone wanting to build
      # Asterisk from other sources. Include in externals.
      # "sounds/asterisk-core-sounds-en-gsm-1.5.tar.gz" = fetchurl {
      #   url = http://downloads.asterisk.org/pub/telephony/sounds/releases/asterisk-core-sounds-en-gsm-1.5.tar.gz;
      #   sha256 = "01xzbg7xy0c5zg7sixjw5025pvr4z64kfzi9zvx19im0w331h4cd";
      # };
      # "sounds/asterisk-moh-opsound-wav-2.03.tar.gz" = fetchurl {
      #   url = http://downloads.asterisk.org/pub/telephony/sounds/releases/asterisk-moh-opsound-wav-2.03.tar.gz;
      #   sha256 = "449fb810d16502c3052fedf02f7e77b36206ac5a145f3dacf4177843a2fcb538";
      # };
      # TODO: Sounds for other languages could be added here
    # }
  # }.overrideDerivation (_: {src = fetchgit {...}})

}
