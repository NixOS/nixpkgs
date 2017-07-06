{ stdenv, fetchgit, autoconf, automake, pkgconfig, gettext, libtool, git, pandoc, which, attr, libiconv }:

stdenv.mkDerivation rec {
  name = "mergerfs-${version}";
  version = "2.22.1";

  # not using fetchFromGitHub because of changelog being built with git log
  src = fetchgit {
    url = "https://github.com/trapexit/mergerfs";
    rev = "refs/tags/${version}";
    sha256 = "12dm64l74wyagbwxsz57p8j3dwl9hgi0j3b6i0pn9m5ar7qrnv00";
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
