{ lib, stdenv, fetchFromGitHub, fuse3, macfuse-stubs, pkg-config, pcre }:

let
  fuse = if stdenv.isDarwin then macfuse-stubs else fuse3;
in stdenv.mkDerivation rec {
  pname = "tup";
  version = "0.7.10";
  outputs = [ "bin" "man" "out" ];

  src = fetchFromGitHub {
    owner = "gittup";
    repo = "tup";
    rev = "v${version}";
    sha256 = "1qd07h4wi0743l7z2vybfvhwp61g2p2pc5qhl40672ryl24nvd1d";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse pcre ];

  configurePhase = ''
    sed -i 's/`git describe`/v${version}/g' src/tup/link.sh
    sed -i 's/pcre-confg/pkg-config pcre/g' Tupfile Tuprules.tup
  '';

  # Regular tup builds require fusermount to have suid, which nix cannot
  # currently provide in a build environment, so we bootstrap and use 'tup
  # generate' instead
  buildPhase = ''
    ./build.sh
    ./build/tup init
    ./build/tup generate script.sh
    ./script.sh
  '';

  installPhase = ''
    install -D tup -t $bin/bin/
    install -D tup.1 -t $man/share/man/man1/
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "A fast, file-based build system";
    longDescription = ''
      Tup is a file-based build system for Linux, OSX, and Windows. It inputs a list
      of file changes and a directed acyclic graph (DAG), then processes the DAG to
      execute the appropriate commands required to update dependent files. Updates are
      performed with very little overhead since tup implements powerful build
      algorithms to avoid doing unnecessary work. This means you can stay focused on
      your project rather than on your build system.
    '';
    homepage = "http://gittup.org/tup/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.unix;

    # TODO: Remove once nixpkgs uses newer SDKs that supports '*at' functions.
    # Probably MacOS SDK 10.13 or later. Check the current version in
    # ../../../../os-specific/darwin/apple-sdk/default.nix
    #
    # https://github.com/gittup/tup/commit/3697c74
    broken = stdenv.isDarwin;
  };
}
