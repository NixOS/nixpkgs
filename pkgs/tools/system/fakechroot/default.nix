{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, perl }:

stdenv.mkDerivation rec {
  pname = "fakechroot";
  version = "2.20.1";

  src = fetchFromGitHub {
    owner  = "dex4er";
    repo   = pname;
    rev    = version;
    sha256 = "0xgnwazrmrg4gm30xjxdn6sx3lhqvxahrh6gmy3yfswxc30pmg86";
  };

  # Use patch from https://github.com/dex4er/fakechroot/pull/46 , remove once merged!
  # Courtesy of one of our own, @copumpkin!
  patches = [
    (fetchpatch {
      url = "https://github.com/dex4er/fakechroot/pull/46/commits/dcc0cfe3941e328538f9e62b2c0b15430d393ec1.patch";
      sha256 = "1mk8j2njd94s7vf2wggi08xxxzx8dxrvdricl9cbspvkyp715w2m";
      # Don't bother trying to reconcile conflicts for NEWS entries, as they will continue to occur
      # and are uninteresting as well as unimportant for our purposes (since NEWS never leaves the build env).
      excludes = [ "NEWS.md" ];
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/dex4er/fakechroot";
    description = "Give a fake chroot environment through LD_PRELOAD";
    license = licenses.lgpl21;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };

}
