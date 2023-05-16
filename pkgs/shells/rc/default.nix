<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, pkgsStatic
, byacc
, ed
, ncurses
, readline
, installShellFiles
, historySupport ? true
, readlineSupport ? true
, lineEditingLibrary ? if (stdenv.hostPlatform.isDarwin
                           || stdenv.hostPlatform.isStatic)
                       then "null"
                       else "readline"
}:

assert lib.elem lineEditingLibrary [ "null" "edit" "editline" "readline" "vrl" ];
assert !(lib.elem lineEditingLibrary [ "edit" "editline" "vrl" ]); # broken
assert (lineEditingLibrary == "readline") -> readlineSupport;
stdenv.mkDerivation (finalAttrs: {
  pname = "rc";
  version = "unstable-2023-06-14";
=======
{ lib, stdenv, fetchFromGitHub, autoreconfHook, byacc
, ncurses, readline, pkgsStatic
, historySupport ? false, readlineSupport ? true }:

stdenv.mkDerivation rec {
  pname = "rc";
  version = "unstable-2021-08-03";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rakitzis";
    repo = "rc";
<<<<<<< HEAD
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
    "EDIT=${lineEditingLibrary}"
  ];

  buildFlags = [
    "all"
  ] ++ lib.optionals historySupport [
    "history"
  ];

  postInstall = lib.optionalString historySupport ''
    installManPage history.1
=======
    rev = "8ca9ab1305c3e30cd064290081d6e5a1fa841d26";
    sha256 = "0744ars6y9zzsjr9xazms91qy6bi7msg2gg87526waziahfh4s4z";
  };

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook byacc ];

  # acinclude.m4 wants headers for tgetent().
  buildInputs = [ ncurses ]
    ++ lib.optionals readlineSupport [ readline ];

  CPPFLAGS = ["-DSIGCLD=SIGCHLD"];

  configureFlags = [
    "--enable-def-interp=${stdenv.shell}" #183
    ] ++ lib.optionals historySupport [ "--with-history" ]
    ++ lib.optionals readlineSupport [ "--with-edit=readline" ];

  #reproducible-build
  postPatch = ''
    substituteInPlace configure.ac \
      --replace "$(git describe || echo '(git description unavailable)')" "${builtins.substring 0 7 src.rev}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  passthru = {
    shellPath = "/bin/rc";
    tests.static = pkgsStatic.rc;
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/rakitzis/rc";
    description = "The Plan 9 shell";
    license = [ lib.licenses.zlib ];
    mainProgram = "rc";
    maintainers = with lib.maintainers; [ ramkromberg AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
=======
  meta = with lib; {
    description = "The Plan 9 shell";
    longDescription = "Byron Rakitzis' UNIX reimplementation of Tom Duff's Plan 9 shell";
    homepage = "https://web.archive.org/web/20180820053030/tobold.org/article/rc";
    license = with licenses; zlib;
    maintainers = with maintainers; [ ramkromberg ];
    mainProgram = "rc";
    platforms = with platforms; all;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
