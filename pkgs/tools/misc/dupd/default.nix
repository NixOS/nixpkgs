{ lib, stdenv, fetchFromGitHub, perl, which
, openssl, sqlite }:

# Instead of writing directly into $HOME, we change the default db location
# from $HOME/.dupd_sqlite to $HOME/.cache/dupd.sqlite3

stdenv.mkDerivation rec {
  pname = "dupd";
<<<<<<< HEAD
  version = "1.7.3";
=======
  version = "1.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jvirkki";
    repo  = "dupd";
    rev   = version;
<<<<<<< HEAD
    sha256 = "sha256-ZiQroJ5fjBCIjU+M8KRA0N3Mrg9h0NVtfYUIS4cYyhw=";
=======
    sha256 = "sha256-jDFPvJqIUEu0/8bvq2PaaA1NnWakApegW8bxn+NKffs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    patchShebangs tests

    # tests need HOME to write the database
    export HOME=$TMPDIR

    mkdir -p $HOME/.cache

    for f in man/dupd man/dupd.1 src/main.c tests/test.56 tests/test.57 ; do
      substituteInPlace $f --replace .dupd_sqlite .cache/dupd.sqlite3
    done
  '';

  buildInputs = [ openssl sqlite ];

  nativeBuildInputs = [ perl which ];

  makeFlags = [
    "INSTALL_PREFIX=$(out)"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "CLI utility to find duplicate files";
    homepage = "http://www.virkki.com/dupd";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
