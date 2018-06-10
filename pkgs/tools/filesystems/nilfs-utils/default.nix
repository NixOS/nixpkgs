{ stdenv, fetchurl, fetchpatch, libuuid, libselinux }:
let 
  sourceInfo = rec {
    version = "2.2.7";
    url = "http://nilfs.sourceforge.net/download/nilfs-utils-${version}.tar.bz2";
    sha256 = "01f09bvjk2crx65pxmxiw362wkkl3v2v144dfn3i7bk5gz253xic";
    baseName = "nilfs-utils";
    name = "${baseName}-${version}";
  };
in
stdenv.mkDerivation rec {
  src = fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.sha256;
  };

  inherit (sourceInfo) name version;
  buildInputs = [libuuid libselinux];

  preConfigure = ''
    sed -e '/sysconfdir=\/etc/d; ' -i configure
    sed -e "s@sbindir=/sbin@sbindir=$out/sbin@" -i configure
    sed -e 's@/sbin/@'"$out"'/sbin/@' -i ./lib/cleaner*.c
  '';

  patches = [
    # Fix w/musl
    (fetchpatch {
      url = "https://github.com/nilfs-dev/nilfs-utils/commit/115fe4b976858c487cf83065f513d8626089579a.patch";
      sha256 = "0h89jz9l5d4rqj647ljbnv451l4ncqpsvzj0v70mn5391hfwsjlv";
    })
    (fetchpatch {
      url =  "https://github.com/nilfs-dev/nilfs-utils/commit/51b32c614be9e98c32de7f531ee600ca0740946f.patch";
      sha256 = "1ycq83c6jjy74aif47v075k5y2szzwhq6mbcrpd1z4b4i1x6yhpn";
    })
  ];

  # FIXME: https://github.com/NixOS/patchelf/pull/98 is in, but stdenv
  # still doesn't use it
  #
  # To make sure patchelf doesn't mistakenly keep the reference via
  # build directory
  postInstall = ''
    find . -name .libs | xargs rm -rf
  '';

  meta = {
    description = "NILFS utilities";
    maintainers = with stdenv.lib.maintainers;
    [
      raskin
    ];
    platforms = with stdenv.lib.platforms;
      linux;
    downloadPage = "http://nilfs.sourceforge.net/en/download.html";
    updateWalker = true;
  };
}
