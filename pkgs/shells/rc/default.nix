{ stdenv, fetchurl, autoreconfHook
, ncurses #acinclude.m4 wants headers for tgetent().
, historySupport ? false
, readline ? null
}:

stdenv.mkDerivation rec {
  name = "rc-${version}";
  version = "1.7.4";

  src = fetchurl {
    url = "http://static.tobold.org/rc/rc-${version}.tar.gz";
    sha256 = "1n5zz6d6z4z6s3fwa0pscqqawy561k4xfnmi91i626hcvls67ljy";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses ]
    ++ stdenv.lib.optionals (readline != null) [ readline ];

  configureFlags = [
    "--enable-def-interp=${stdenv.shell}" #183
    ] ++ stdenv.lib.optionals historySupport [ "--with-history" ]
    ++ stdenv.lib.optionals (readline != null) [ "--with-edit=readline" ];

  prePatch = ''
    substituteInPlace configure.ac \
      --replace "date -I" "echo 2015-05-13" #reproducible-build
  '';

  passthru = {
    shellPath = "/bin/rc";
  };

  meta = with stdenv.lib; {
    description = "The Plan 9 shell";
    longDescription = "Byron Rakitzis' UNIX reimplementation of Tom Duff's Plan 9 shell.";
    homepage = http://tobold.org/article/rc;
    license = with licenses; zlib;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; all;
  };
}
