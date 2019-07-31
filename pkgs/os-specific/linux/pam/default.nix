{ stdenv, buildPackages, fetchurl, fetchpatch, flex, cracklib, db4, redHatModules ? false, autoreconfHook ? null, yacc ? null, pkgconfig ? null, libxslt ? null, libxml2 ? null, docbook_xsl ? null, docbook_xml_dtd_44 ? null, docbook_xml_dtd_43 ? null, w3m ? null, docbook_xml_dtd_412 ? null }:

assert redHatModules -> stdenv.lib.all (x: x != null) [ autoreconfHook yacc pkgconfig libxslt libxml2 docbook_xsl docbook_xml_dtd_44 docbook_xml_dtd_43 w3m ];

let

  redHatModulesVersion = "1.0.0";
  redHatModulesSource = fetchTarball {
    url = "https://releases.pagure.org/pam-redhat/pam-redhat-${redHatModulesVersion}.tar.bz2";
    sha256 = "0ssrvlxll5nxi2wrvch1l4sbl04yvyivyzc9k51l77l1xjqrjd45";
  };

in

  stdenv.mkDerivation rec {
    name = "linux-pam-${version}";
    version = "1.3.1";

    src = fetchurl {
      url    = "https://github.com/linux-pam/linux-pam/releases/download/v${version}/Linux-PAM-${version}.tar.xz";
      sha256 = "1nyh9kdi3knhxcbv5v4snya0g3gff0m671lnvqcbygw3rm77mx7g";
    };

    patches =
      (stdenv.lib.optionals redHatModules [
        ./respect-xml-catalog-files-var.patch
        ./dont-touch-var-console.patch
        (fetchpatch {
          url = "https://src.fedoraproject.org/rpms/pam/raw/daf508b4d60c4ed7f980512b721d99ebbb34b602/f/pam-1.3.1-redhat-modules.patch";
          sha256 = "1ypys1hcv391hqxf09jmqqp95lli6a8kw4p40nngg64znjgcx22c";
        })
      ]) ++
      (stdenv.lib.optionals (stdenv.hostPlatform.libc == "musl") [
        (fetchpatch {
          url = "https://git.alpinelinux.org/cgit/aports/plain/main/linux-pam/fix-compat.patch?id=05a62bda8ec255d7049a2bd4cf0fdc4b32bdb2cc";
          sha256 = "1h5yp5h2mqp1fcwiwwklyfpa69a3i03ya32pivs60fd7g5bqa7sf";
        })
        (fetchpatch {
          url = "https://git.alpinelinux.org/cgit/aports/plain/main/linux-pam/libpam-fix-build-with-eglibc-2.16.patch?id=05a62bda8ec255d7049a2bd4cf0fdc4b32bdb2cc";
          sha256 = "1ib6shhvgzinjsc603k2x1lxh9dic6qq449fnk110gc359m23j81";
        })
        # From adelie's package repo, using local copy since it seems to be currently offline.
        # (we previously used similar patch from void, but stopped working with update to 1.3.1)
        ./musl-fix-pam_exec.patch
      ]);

    outputs = [ "out" "doc" "man" /* "modules" */ ];

    depsBuildBuild = [ buildPackages.stdenv.cc ];
    nativeBuildInputs = [ flex ] ++ ( stdenv.lib.optionals redHatModules [ autoreconfHook yacc pkgconfig libxslt.bin docbook_xml_dtd_44 docbook_xml_dtd_43 docbook_xsl libxml2 ( w3m.override { graphicsSupport = false; } ) docbook_xml_dtd_412 ] );

    buildInputs = [ cracklib db4 ];

    enableParallelBuilding = true;

    prePatch = stdenv.lib.optionalString redHatModules ''
      cp -r --no-preserve=all ${redHatModulesSource}/* modules
    '';

    postInstall = ''
      mv -v $out/sbin/unix_chkpwd{,.orig}
      ln -sv /run/wrappers/bin/unix_chkpwd $out/sbin/unix_chkpwd
    ''; /*
      rm -rf $out/etc
      mkdir -p $modules/lib
      mv $out/lib/security $modules/lib/
    '';*/
    # don't move modules, because libpam needs to (be able to) find them,
    # which is done by dlopening $out/lib/security/pam_foo.so
    # $out/etc was also missed: pam_env(login:session): Unable to open config file

    preConfigure = ''
      configureFlags="$configureFlags --includedir=$out/include/security"
    '' + stdenv.lib.optionalString (stdenv.hostPlatform.libc == "musl") ''
        # export ac_cv_search_crypt=no
        # (taken from Alpine linux, apparently insecure but also doesn't build O:))
        # disable insecure modules
        # sed -e 's/pam_rhosts//g' -i modules/Makefile.am
        sed -e 's/pam_rhosts//g' -i modules/Makefile.in
    '';

    doCheck = false; # fails

    meta = with stdenv.lib; {
      homepage = http://www.linux-pam.org/;
      description = "Pluggable Authentication Modules, a flexible mechanism for authenticating user";
      platforms = platforms.linux;
      license = licenses.bsd3;
    };
  }
