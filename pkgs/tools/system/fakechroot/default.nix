{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, nixosTests, perl }:

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

    # glibc 2.33 compat (https://github.com/dex4er/fakechroot/pull/85/)
    (fetchpatch {
      url = "https://github.com/dex4er/fakechroot/commit/534e6d555736b97211523970d378dfb0db2608e9.patch";
      sha256 = "sha256-bUlGJZvOSrATPt8bxGqU1UETTUD9V/HhJyA5ZxsOLQU=";
    })
    (fetchpatch {
      url = "https://github.com/dex4er/fakechroot/commit/75d7e6fa191c11a791faff06a0de86eaa7801d05.patch";
      sha256 = "sha256-vWN7zFkKlBd/F+h/66z21RiZqkSCn3UIzy9NHV7TYDg=";
    })
    (fetchpatch {
      url = "https://github.com/dex4er/fakechroot/commit/693a3597ea7fccfb62f357503ff177bd3e3d5a89.patch";
      sha256 = "sha256-bFXsT0hWocJFbtS1cpzo7oIy/x66iUw6QE1/cEoZ+3k=";
    })
    (fetchpatch {
      url = "https://github.com/dex4er/fakechroot/commit/e7c1f3a446e594a4d0cce5f5d499c9439ce1d5c5.patch";
      sha256 = "sha256-eX6kB4U1ZlXoRtkSVEIBTRjO/cTS/7z5a9S366DiRMg=";
    })
    # pass __readlinkat_chk buffer length
    (fetchpatch {
      url = "https://github.com/dex4er/fakechroot/pull/115/commits/15479d9436b534cee0115064bd8deb8d4ece9b8c.patch";
      hash = "sha256-wMIZ3hW5XkRXQYBMADlN6kxhDSiEr84PGWBW+f4b4Ko=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ perl ];

  passthru = {
    tests = {
      # A lightweight *unit* test that exercises fakeroot and fakechroot together:
      nixos-etc = nixosTests.etc.test-etc-fakeroot;
    };
  };

  meta = with lib; {
    homepage = "https://github.com/dex4er/fakechroot";
    description = "Give a fake chroot environment through LD_PRELOAD";
    license = licenses.lgpl21;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };

}
