{ lib, stdenv, fetchurl, fetchpatch, getopt, libcap, gnused }:

stdenv.mkDerivation rec {
  version = "1.23";
  pname = "fakeroot";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/f/fakeroot/fakeroot_${version}.orig.tar.xz";
    sha256 = "1xpl0s2yjyjwlf832b6kbkaa5921liybaar13k7n45ckd9lxd700";
  };

  patches = lib.optionals stdenv.isLinux [
    ./einval.patch

    # glibc 2.33 patches from ArchLinux
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/15b01cf37ff64c487f7440df4e09b090cd93b58f/fakeroot/trunk/fakeroot-1.25.3-glibc-2.33-fix-1.patch";
      sha256 = "sha256-F6BcxYInSLu7Fxg6OmMZDhTWoLqsc//yYPlTZqQQl68=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/15b01cf37ff64c487f7440df4e09b090cd93b58f/fakeroot/trunk/fakeroot-1.25.3-glibc-2.33-fix-2.patch";
      sha256 = "sha256-ifpJxhk6MyQpFolC1hIAAUjcHmOHVU1D25tRwpu2S/k=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/15b01cf37ff64c487f7440df4e09b090cd93b58f/fakeroot/trunk/fakeroot-1.25.3-glibc-2.33-fix-3.patch";
      sha256 = "sha256-o2Xm4C64Ny9TL8fjsZltjO1CdJ4VGwqZ+LnufVL5Sq8=";
    })
  ]
  # patchset from brew
  ++ lib.optionals stdenv.isDarwin [
    (fetchpatch {
      name = "0001-Implement-openat-2-wrapper-which-handles-optional-ar.patch";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=0001-Implement-openat-2-wrapper-which-handles-optional-ar.patch;att=1;bug=766649";
      sha256 = "1m6ggrqwqy0in264sxqk912vniipiw629dxq7kibakvsswfk6bkk";
    })
    (fetchpatch {
      name = "0002-OS-X-10.10-introduced-id_t-int-in-gs-etpriority.patch";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=0002-OS-X-10.10-introduced-id_t-int-in-gs-etpriority.patch;att=2;bug=766649";
      sha256 = "0rhayp42x4i1a6yc4d28kpshmf7lrmaprq64zfrjpdn4kbs0rkln";
    })
    (fetchpatch {
      name = "fakeroot-always-pass-mode.patch";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=2;bug=766649;filename=fakeroot-always-pass-mode.patch;msg=20";
      sha256 = "0i3zaca1v449dm9m1cq6wq4dy6hc2y04l05m9gg8d4y4swld637p";
    })
  ];

  buildInputs = [ getopt gnused ]
    ++ lib.optional (!stdenv.isDarwin) libcap
    ;

  postUnpack = ''
    sed -i -e "s@getopt@$(type -p getopt)@g" -e "s@sed@$(type -p sed)@g" ${pname}-${version}/scripts/fakeroot.in
  '';

  postConfigure = let
    # additional patch from brew, but needs to be applied to a generated file
    patch-wraptmpf = fetchpatch {
      name = "fakeroot-patch-wraptmpf-h.patch";
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=3;bug=766649;filename=fakeroot-patch-wraptmpf-h.patch;msg=20";
      sha256 = "1jhsi4bv6nnnjb4vmmmbhndqg719ckg860hgw98bli8m05zwbx6a";
    };
  in lib.optional stdenv.isDarwin ''
    make wraptmpf.h
    patch -p1 < ${patch-wraptmpf}
  '';

  meta = {
    homepage = "https://salsa.debian.org/clint/fakeroot";
    description = "Give a fake root environment through LD_PRELOAD";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = lib.platforms.unix;
  };

}
