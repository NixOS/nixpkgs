{ stdenv, fetchurl, fetchpatch, getopt, libcap }:

stdenv.mkDerivation rec {
  version = "1.20.2";
  name = "fakeroot-${version}";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/f/fakeroot/fakeroot_${version}.orig.tar.bz2";
    sha256 = "0313xb2j6a4wihrw9gfd4rnyqw7zzv6wf3rfh2gglgnv356ic2kw";
  };

  # patchset from brew
  patches = stdenv.lib.optionals stdenv.isDarwin [
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

  buildInputs = [ getopt ]
    ++ stdenv.lib.optional (!stdenv.isDarwin) libcap
    ;

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
    platforms = stdenv.lib.platforms.unix;
  };

}
