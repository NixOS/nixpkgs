{ stdenv, fetchurl, utillinux, libcap }:

stdenv.mkDerivation rec {
  version = "1.20.2";
  name = "fakeroot-${version}";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/f/fakeroot/fakeroot_${version}.orig.tar.bz2";
    sha256 = "0313xb2j6a4wihrw9gfd4rnyqw7zzv6wf3rfh2gglgnv356ic2kw";
  };

  buildInputs = [ utillinux /* provides getopt */ libcap ];

  postUnpack = ''
    for prog in getopt; do
      sed -i "s@getopt@$(type -p getopt)@g" ${name}/scripts/fakeroot.in
    done
  '';

  meta = {
    homepage = http://fakeroot.alioth.debian.org/;
    description = "Give a fake root environment through LD_PRELOAD";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

}
