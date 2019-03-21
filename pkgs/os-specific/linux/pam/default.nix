{ stdenv, buildPackages, fetchurl, fetchpatch, flex, cracklib, db4 }:

stdenv.mkDerivation rec {
  name = "linux-pam-${version}";
  version = "1.3.0";

  src = fetchurl {
    url = "http://www.linux-pam.org/library/Linux-PAM-${version}.tar.bz2";
    sha256 = "1fyi04d5nsh8ivd0rn2y0z83ylgc0licz7kifbb6xxi2ylgfs6i4";
  };

  patches = stdenv.lib.optionals (stdenv.hostPlatform.libc == "musl") [
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/linux-pam/fix-compat.patch?id=05a62bda8ec255d7049a2bd4cf0fdc4b32bdb2cc";
      sha256 = "1h5yp5h2mqp1fcwiwwklyfpa69a3i03ya32pivs60fd7g5bqa7sf";
    })
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/linux-pam/libpam-fix-build-with-eglibc-2.16.patch?id=05a62bda8ec255d7049a2bd4cf0fdc4b32bdb2cc";
      sha256 = "1ib6shhvgzinjsc603k2x1lxh9dic6qq449fnk110gc359m23j81";
    })
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/main/linux-pam/musl-fix-pam_exec.patch?id=05a62bda8ec255d7049a2bd4cf0fdc4b32bdb2cc";
      sha256 = "04dx6s9d8cxl40r7m7dc4si47ds4niaqm7902y1d6wcjvs11vrf0";
    })
  ];

  outputs = [ "out" "doc" "man" /* "modules" */ ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ flex ];

  buildInputs = [ cracklib db4 ];

  enableParallelBuilding = true;

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
