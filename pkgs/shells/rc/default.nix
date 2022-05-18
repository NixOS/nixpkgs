{ lib, stdenv, fetchFromGitHub, autoreconfHook, byacc
, ncurses, readline
, historySupport ? false, readlineSupport ? true }:

stdenv.mkDerivation rec {
  pname = "rc";
  version = "unstable-2021-08-03";

  src = fetchFromGitHub {
    owner = "rakitzis";
    repo = "rc";
    rev = "8ca9ab1305c3e30cd064290081d6e5a1fa841d26";
    sha256 = "0744ars6y9zzsjr9xazms91qy6bi7msg2gg87526waziahfh4s4z";
  };

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook byacc ];

  # acinclude.m4 wants headers for tgetent().
  buildInputs = [ ncurses ]
    ++ lib.optionals readlineSupport [ readline ];

  configureFlags = [
    "--enable-def-interp=${stdenv.shell}" #183
    ] ++ lib.optionals historySupport [ "--with-history" ]
    ++ lib.optionals readlineSupport [ "--with-edit=readline" ];

  #reproducible-build
  postPatch = ''
    substituteInPlace configure.ac \
      --replace "$(git describe || echo '(git description unavailable)')" "${builtins.substring 0 7 src.rev}"
  '';

  passthru.shellPath = "/bin/rc";

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
