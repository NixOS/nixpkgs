{ lib, stdenv, fetchurl, pkg-config, fuse }:

stdenv.mkDerivation rec {
  pname = "djmount";
  version = "0.71";
  src = fetchurl {
    url = "mirror://sourceforge/djmount/${version}/${pname}-${version}.tar.gz";
    sha256 = "0kqf0cy3h4cfiy5a2sigmisx0lvvsi1n0fbyb9ll5gacmy1b8nxa";
  };

  postPatch = ''
    # Taken from https://github.com/pupnp/pupnp/pull/334/files
    substituteInPlace libupnp/threadutil/inc/ithread.h \
      --replace \
        "#define ithread_mutexattr_setkind_np pthread_mutexattr_setkind_np" \
        '#define ithread_mutexattr_setkind_np pthread_mutexattr_settype'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse];

  meta = {
    homepage = "http://djmount.sourceforge.net/";
    description = "UPnP AV client, mounts as a Linux filesystem the media content of compatible UPnP AV devices";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jagajaga ];
    license = lib.licenses.gpl2;
  };
}
