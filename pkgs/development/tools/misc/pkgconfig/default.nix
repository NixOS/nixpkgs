{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "pkg-config-0.26";
  
  setupHook = ./setup-hook.sh;
  
  src = fetchurl {
    url = "http://pkgconfig.freedesktop.org/releases/${name}.tar.gz";
    sha256 = "1by86fjr5i6l7l428bdk4axcls32bcb598g5wjrhz4vwg5m97hcl";
  };

  patches = [
    # Process Requires.private properly, see
    # http://bugs.freedesktop.org/show_bug.cgi?id=4738.
    ./requires-private.patch
  ];

  meta = {
    description = "A tool that allows packages to find out information about other packages";
    homepage = http://pkg-config.freedesktop.org/wiki/;
  };

}

