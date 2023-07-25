{ lib, stdenv, fetchFromGitHub, fuse3, macfuse-stubs, pkg-config, sqlite, pcre }:

let
  fuse = if stdenv.isDarwin then macfuse-stubs else fuse3;
in stdenv.mkDerivation rec {
  pname = "tup";
  version = "0.7.11";
  outputs = [ "bin" "man" "out" ];

  src = fetchFromGitHub {
    owner = "gittup";
    repo = "tup";
    rev = "v${version}";
    hash = "sha256-Q2Y5ErcfhLChi9Wezn8+7eNXYX2UXW1fBOqEclmgzOo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse pcre sqlite ];

  patches = [ ./fusermount-setuid.patch ];

  configurePhase = ''
    substituteInPlace  src/tup/link.sh --replace '`git describe' '`echo ${version}'

    for f in Tupfile Tuprules.tup src/tup/server/Tupfile build.sh; do
      substituteInPlace "$f" \
        --replace "pkg-config"  "${stdenv.cc.targetPrefix}pkg-config" \
        --replace "pcre-config" "${stdenv.cc.targetPrefix}pkg-config libpcre"
    done

    cat << EOF > tup.config
    CONFIG_CC=${stdenv.cc.targetPrefix}cc
    CONFIG_AR=${stdenv.cc.targetPrefix}ar
    CONFIG_TUP_USE_SYSTEM_SQLITE=y
    EOF
  '';

  # Regular tup builds require fusermount to have suid, which nix cannot
  # currently provide in a build environment, so we bootstrap and use 'tup
  # generate' instead
  buildPhase = ''
    runHook preBuild
    ./build.sh
    ./build/tup init
    ./build/tup generate script.sh
    ./script.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D tup -t $bin/bin/
    install -D tup.1 -t $man/share/man/man1/
    runHook postInstall
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
    homepage = "https://gittup.org/tup/";
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
