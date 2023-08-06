{ lib
, stdenv
, fetchFromGitHub
, byacc
, ed
, ncurses
, readline
, installShellFiles
, pkgsStatic
, historySupport ? true
, readlineSupport ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rc";
  version = "unstable-2023-06-14";

  src = fetchFromGitHub {
    owner = "rakitzis";
    repo = "rc";
    rev = "4aaba1a9cb9fdbb8660696a87850836ffdb09599";
    hash = "sha256-Yql3mt7hTO2W7wTfPje+X2zBGTHiNXGGXYORJewJIM8=";
  };

  outputs = [ "out" "man" ];

  # TODO: think on a less ugly fixup
  postPatch = ''
    ed -v -s Makefile << EOS
    # - remove reference to now-inexistent git index file
    /version.h:/ s| .git/index||
    # - manually insert the git revision string
    /v=/ c
    ${"\t"}v=${builtins.substring 0 7 finalAttrs.src.rev}
    .
    /\.git\/index:/ d
    w
    q
    EOS
  '';

  nativeBuildInputs = [
    byacc
    ed
    installShellFiles
  ];

  buildInputs = [
    ncurses
  ]
  ++ lib.optionals readlineSupport [
    readline
  ];

  strictDeps = true;

  makeFlags  = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
    "MANPREFIX=${placeholder "man"}/share/man"
    "CPPFLAGS=\"-DSIGCLD=SIGCHLD\""
  ];

  buildFlags = [
    "all"
  ] ++ lib.optionals historySupport [
    "history"
  ];

  postInstall = lib.optionalString historySupport ''
    installManPage history.1
  '';

  passthru = {
    shellPath = "/bin/rc";
    tests.static = pkgsStatic.rc;
  };

  meta = {
    homepage = "https://github.com/rakitzis/rc";
    description = "The Plan 9 shell";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [ ramkromberg AndersonTorres ];
    platforms = lib.platforms.unix;
    mainProgram = "rc";
  };
})
