{ stdenv, fetchurl, libmtp }:

stdenv.mkDerivation rec {
  version = "0.2";
  name = "simple-mtpfs-${version}";

  buildInputs = [ libmtp ];

  src = fetchurl {
    url = "https://github.com/phatina/simple-mtpfs/archive/${name}.tar.gz";
    sha256 = "1shmqp0cmhwbccxa1ry3by5ynw5drnk94lnidam4244pjjqizr1w";
  };

  meta = {
    homepage = https://github.com/phatina/simple-mtpfs;
    description = "Simple MTP fuse filesystem driver.";
    platforms = stdenv.lib.platforms.linux; # can only test linux
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
  };
}
