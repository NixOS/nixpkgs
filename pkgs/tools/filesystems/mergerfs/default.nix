{ stdenv, fetchgit, autoconf, automake, pkgconfig, gettext, libtool, git, pandoc, which, attr, libiconv }:

stdenv.mkDerivation rec {
  name = "mergerfs-${version}";
  version = "2.23.0";

  # not using fetchFromGitHub because of changelog being built with git log
  src = fetchgit {
    url = "https://github.com/trapexit/mergerfs";
    rev = "refs/tags/${version}";
    sha256 = "0k4nn0f4c355q7hnni7iia8qi9m0khvyd04hx1hmlrnf0zsi9mfw";
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
