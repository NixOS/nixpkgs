{lib, stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  pname = "checkinstall";
  version = "1.6.2";

  src = fetchurl {
    url = "https://www.asic-linux.com.mx/~izto/checkinstall/files/source/checkinstall-${version}.tar.gz";
    sha256 = "1x4kslyvfd6lm6zd1ylbq2pjxrafb77ydfjaqi16sa5qywn1jqfw";
  };

  patches = [
    # Include empty directories created by the installation script in
    # generated packages.  (E.g., if a `make install' does `mkdir
    # /var/lib/mystuff', then /var/lib/mystuff should be included in
    # the package.)
    ./empty-dirs.patch

    # Implement the getxattr(), lgetxattr(), __open_2() and
    # __open64_2() functions.  Needed for doing builds on Ubuntu 8.10.
    ./missing-functions.patch

    # Don't include directories in the Debian `conffiles' file.
    ./etc-dirs.patch

    # Support Glibc >= 2.8.
    ./glibc-check.patch

    # Fix a `conflicting types for 'scandir'' error on Glibc 2.11.
    ./scandir.patch

    # Fix a `conflicting types for 'readlink'' error since Glibc 2.19
    ./readlink-types.patch

    # Fix BuildRoot handling in RPM builds.
    ./set-buildroot.patch
  ]

  ++ lib.optional (stdenv.hostPlatform.system == "x86_64-linux")
    # Force use of old memcpy so that installwatch works on Glibc <
    # 2.14.
    ./use-old-memcpy.patch;

  buildInputs = [gettext];

  hardeningDisable = [ "fortify" ];

  preBuild = ''
    makeFlagsArray=(PREFIX=$out)

    substituteInPlace checkinstall --replace /usr/local/lib/checkinstall $out/lib/checkinstall
    substituteInPlace checkinstallrc-dist --replace /usr/local $out

    substituteInPlace installwatch/create-localdecls \
      --replace /usr/include/unistd.h ${stdenv.cc.libc.dev}/include/unistd.h
  '';

  postInstall =
    # Clear the RPATH, otherwise installwatch.so won't work properly
    # as an LD_PRELOADed library on applications that load against a
    # different Glibc.
    ''
       patchelf --set-rpath "" $out/lib/installwatch.so
    '';

  meta = {
    homepage = "http://checkinstall.izto.org/";
    description = "A tool for automatically generating Slackware, RPM or Debian packages when doing `make install'";
    maintainers = [ lib.maintainers.eelco ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    knownVulnerabilities = [
      "CVE-2020-25031"
    ];
  };
}
