{ stdenv, fetchhg, autoreconfHook, zlib, darwin }:

stdenv.mkDerivation rec {
  name = "atomicparsley-${version}";
  version = "0.9.6";

  src = fetchhg {
    url = "https://bitbucket.org/wez/atomicparsley";
    sha256 = "05n4kbn91ps52h3wi1qb2jwygjsc01qzx4lgkv5mvwl5i49rj8fm";
  };

  buildInputs =
    [ autoreconfHook
      zlib
    ] ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Cocoa;

  installPhase = "install -D AtomicParsley $out/bin/AtomicParsley";

  meta = with stdenv.lib; {
    description = ''
      A lightweight command line program for reading, parsing and
      setting metadata into MPEG-4 files
    '';

    longDescription = ''
      This is a maintained fork of the original AtomicParsley.
    '';

    homepage = https://bitbucket.org/wez/atomicparsley;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pjones ];
  };
}
