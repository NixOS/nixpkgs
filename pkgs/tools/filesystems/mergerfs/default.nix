{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, gettext, libtool, git, pandoc, which, attr, libiconv }:

stdenv.mkDerivation rec {
  name = "mergerfs-${version}";
  version = "2.23.0";

  # not using fetchFromGitHub because of changelog being built with git log
  src = fetchFromGitHub {
    owner = "trapexit";
    repo = "mergerfs";
    rev = "refs/tags/${version}";
    sha256 = "0mpmfzhimja79acici1vgba6mzbxjgm4wdl3g00fc1d12svv7n8f";
    deepClone = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [ autoconf automake pkgconfig gettext libtool git pandoc which ];
  buildInputs = [ attr libiconv ];

  makeFlags = [ "PREFIX=$(out)" "XATTR_AVAILABLE=1" ];

  meta = {
    description = "A FUSE based union filesystem";
    homepage = https://github.com/trapexit/mergerfs;
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jfrankenau makefu ];
  };
}
