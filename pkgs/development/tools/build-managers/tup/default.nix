{ stdenv, fetchFromGitHub, fuse, pkgconfig }:

stdenv.mkDerivation rec {
  name = "tup-${version}";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "gittup";
    repo = "tup";
    rev = "v${version}";
    sha256 = "0jzp1llq6635ldb7j9qb29j2k0x5mblimdqg3179dvva1hv0ia23";
  };

  buildInputs = [ fuse pkgconfig ];

  configurePhase = ''
    sed -i 's/`git describe`/v${version}/g' Tupfile
  '';

  # Regular tup builds require fusermount to have suid, which nix cannot
  # currently provide in a build environment, so we bootstrap and use 'tup
  # generate' instead
  buildPhase = ''
    ./build.sh
    ./build/tup generate script.sh
    ./script.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tup $out/bin/

    mkdir -p $out/share/man/man1
    cp tup.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "A fast, file-based build system";
    longDescription = ''
      Tup is a file-based build system for Linux, OSX, and Windows. It inputs a list
      of file changes and a directed acyclic graph (DAG), then processes the DAG to
      execute the appropriate commands required to update dependent files. Updates are
      performed with very little overhead since tup implements powerful build
      algorithms to avoid doing unnecessary work. This means you can stay focused on
      your project rather than on your build system.
    '';
    homepage = http://gittup.org/tup/;
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
