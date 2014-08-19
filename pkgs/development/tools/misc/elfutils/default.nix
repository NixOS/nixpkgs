{stdenv, fetchurl, m4, zlib, bzip2, bison, flex, gettext}:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  name = "elfutils-${version}";
  version = "0.158";

  src = fetchurl {
    urls = [
      "http://fedorahosted.org/releases/e/l/elfutils/${version}/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "0z9rprmizd7rwb3xwfmz5liii7hbiv3g2arl23h56brm45fay9xy";
  };

  patches = [
    ./CVE-2014-0172.patch
    (fetchurl {
      url = "http://fedorahosted.org/releases/e/l/elfutils/${version}/elfutils-portability.patch";
      sha256 = "0y2fyjis5xrd3g2pcbcm145q2kmh52n5c74w8dwv3hqdp5ky7igd";
    }) ];

  # We need bzip2 in NativeInputs because otherwise we can't unpack the src,
  # as the host-bzip2 will be in the path.
  nativeBuildInputs = [m4 bison flex gettext bzip2];
  buildInputs = [zlib bzip2];

  configureFlags = "--disable-werror";

  crossAttrs = {

    /* Having bzip2 will harm, because anything using elfutils
       as buildInput cross-building, will not be able to run 'bzip2' */
    propagatedBuildInputs = [ zlib.crossDrv ];

    # This program does not cross-build fine. So I only cross-build some parts
    # I need for the linux perf tool.
    # On the awful cross-building:
    # http://comments.gmane.org/gmane.comp.sysutils.elfutils.devel/2005
    #
    # I wrote this testing for the nanonote.
    buildPhase = ''
      pushd libebl
      make
      popd
      pushd libelf
      make
      popd
      pushd libdwfl
      make
      popd
      pushd libdw
      make
      popd
    '';

    installPhase = ''
      pushd libelf
      make install
      popd
      pushd libdwfl
      make install
      popd
      pushd libdw
      make install
      popd
      cp version.h $out/include
    '';
  };

  dontAddDisableDepTrack = true;

  meta = {
    homepage = https://fedorahosted.org/elfutils/;
  };
}
