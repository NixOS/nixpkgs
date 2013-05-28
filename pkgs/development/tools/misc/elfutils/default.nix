{stdenv, fetchurl, m4, zlib, bzip2, bison, flex, gettext}:

# TODO: Look at the hardcoded paths to kernel, modules etc.
stdenv.mkDerivation rec {
  name = "elfutils-${version}";
  version = "0.152";
  
  src = fetchurl {
    urls = [
      "https://fedorahosted.org/releases/e/l/elfutils/${version}/${name}.tar.bz2"
      "mirror://gentoo/distfiles/${name}.tar.bz2"
      ];
    sha256 = "19mlgxyzcwiv64ynj2cibgkiw4qkm3n37kizvy6555dsmlaqfybq";
  };

  patches = [
    (fetchurl {
      url = https://fedorahosted.org/releases/e/l/elfutils/0.152/elfutils-portability.patch;
      sha256 = "0q318w4cvvqv9ps4xcwphapj1gl31isgjyya4y9sm72qj68n61p0";
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
