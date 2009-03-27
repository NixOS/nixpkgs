{stdenv, fetchurl, gettext}:

assert stdenv.isLinux;

stdenv.mkDerivation {
  name = "checkinstall-1.6.2pre20081116";

  src = fetchurl {
    url = http://nixos.org/tarballs/checkinstall-1.6.2pre20081116.tar.bz2;
    sha256 = "0k8i551rcn2g0jxskq2sgy4m85irdf5zsl2q4w9b7npgnybkzsmb";
  };

  patches = [
    # Include empty directories created by the installation script in
    # generated packages.  (E.g., if a `make install' does `mkdir
    # /var/lib/mystuff', then /var/lib/mystuff should be included in
    # the package.)
    ./empty-dirs.patch
  ];

  buildInputs = [gettext];

  preBuild = ''
    makeFlagsArray=(PREFIX=$out)

    substituteInPlace checkinstall --replace /usr/local/lib/checkinstall $out/lib/checkinstall
    substituteInPlace checkinstallrc-dist --replace /usr/local $out

    substituteInPlace installwatch/create-localdecls \
      --replace /usr/include/unistd.h ${stdenv.glibc}/include/unistd.h
  '';

  postInstall =
    # Clear the RPATH, otherwise installwatch.so won't work properly
    # as an LD_PRELOADed library on applications that load against a
    # different Glibc.
    ''
       patchelf --set-rpath "" $out/lib/installwatch.so
    '';

  meta = {
    homepage = http://checkinstall.izto.org/;
    description = "A tool for automatically generating Slackware, RPM or Debian packages when doing `make install'";
  };
}
