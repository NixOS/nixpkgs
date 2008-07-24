{stdenv, fetchurl, log2xmlSupport ? true}:

stdenv.mkDerivation {
  name = "gnumake-3.81";
  
  src = fetchurl {
    url = mirror://gnu/make/make-3.81.tar.bz2;
    md5 = "354853e0b2da90c527e35aabb8d6f1e6";
  };
  
  patches =
    (if log2xmlSupport
        # Provide nested log output for subsequent pretty-printing by
        # nix-log2xml.
        then [ ./log.patch ]
	else [])
    ++
    [
      # Purity: don't look for library dependencies (of the form
      # `-lfoo') in /lib and /usr/lib.  It's a stupid feature anyway.
      # Likewise, when searching for included Makefiles, don't look in
      # /usr/include and friends.
      ./impure-dirs.patch
    ];

  meta = {
    description = "A program for automatically building non-source files from sources";
    homepage = http://www.gnu.org/software/make/;
    license = "GPL";
  };
}
