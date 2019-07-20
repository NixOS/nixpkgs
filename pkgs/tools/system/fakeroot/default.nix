{ stdenv, fetchurl, fetchpatch, getopt, libcap, gnused }:

stdenv.mkDerivation rec {
  version = "1.23";
  name = "fakeroot-${version}";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/f/fakeroot/fakeroot_${version}.orig.tar.xz";
    sha256 = "1xpl0s2yjyjwlf832b6kbkaa5921liybaar13k7n45ckd9lxd700";
  };

  patches = stdenv.lib.optional stdenv.isLinux ./einval.patch
  # patchset from brew
  ++ stdenv.lib.optionals stdenv.isDarwin [
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
    ++ stdenv.lib.optional (!stdenv.isDarwin) libcap
    ;

  postUnpack = ''
    sed -i -e "s@getopt@$(type -p getopt)@g" -e "s@sed@$(type -p sed)@g" ${name}/scripts/fakeroot.in
  '';

  meta = {
    homepage = http://fakeroot.alioth.debian.org/;
    description = "Give a fake root environment through LD_PRELOAD";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.unix;
  };

}
