{ stdenv, fetchFromGitHub, autoreconfHook, perl }:

stdenv.mkDerivation rec {
  name = "fakechroot-${version}";
  version = "2.19";

  # TODO: move back to mainline once https://github.com/dex4er/fakechroot/pull/46 is merged
  src = fetchFromGitHub {
    owner  = "copumpkin";
    repo   = "fakechroot";
    rev    = "dcc0cfe3941e328538f9e62b2c0b15430d393ec1";
    sha256 = "1ls3y97qqfcfd3z0balz94xq1gskfk04pg85x6b7wjw8dm4030qd";
  };

  buildInputs = [ autoreconfHook perl ];

  meta = with stdenv.lib; {
    homepage = https://github.com/dex4er/fakechroot;
    description = "Give a fake chroot environment through LD_PRELOAD";
    license = licenses.lgpl21;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };

}
