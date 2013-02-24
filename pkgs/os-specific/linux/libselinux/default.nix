{ stdenv, fetchurl, pkgconfig, libsepol, pcre }:

stdenv.mkDerivation rec {
  name = "libselinux-${version}";
  version = "2.1.12";
  inherit (libsepol) se_release se_url;

  src = fetchurl {
    url = "${se_url}/${se_release}/libselinux-${version}.tar.gz";
    sha256 = "17navgvljgq35bljzcdwjdj3khajc27s15binr51xkp0h29qgbcd";
  };

  patch_src = fetchurl {
    url = "http://dev.gentoo.org/~swift/patches/libselinux/patchbundle-${name}-r2.tar.gz";
    sha256 = "08zaas8iwyf4w9ll1ylyv4gril1nfarckd5h1l53563sxzyf7dqh";
  };

  patches = [ ./fPIC.patch ]; # libsemanage seems to need -fPIC everywhere

  buildInputs = [ pkgconfig libsepol pcre ];

  prePatch = ''
    tar xvf ${patch_src}
    for p in gentoo-patches/*.patch; do
      patch -p1 < "$p"
    done
  '';

  preInstall = '' makeFlags="$makeFlags PREFIX=$out DESTDIR=$out" '';

  meta = {
    inherit (libsepol.meta) homepage platforms maintainers;
  };
}
