{ stdenv, fetchFromGitHub, libtool }:

stdenv.mkDerivation  rec {
  pname = "sha1collisiondetection";
  version = "2017-02-21";
  name = "${pname}-unstable-${version}";

  src = fetchFromGitHub {
    owner = "cr-marcstevens";
    repo = "${pname}";
    rev = "40ccf5e3537ff6b2e5ceac5747f376a2ef430bec";
    sha256 = "1k2qjarcx88ndc4yl8xnr1l3j74w1qacvyrhv4ms9hndy8lrsm0l";
  };

  patchPhase = ''substituteInPlace Makefile --replace "shell arch" "uname -m"'';

  buildInputs = [ libtool ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp bin/sha1dcsum bin/sha1dcsum_partialcoll $out/bin
    cp bin/libdetectcoll.la $out/lib/
    '';

  meta = with stdenv.lib; {
    description = "Library and command line tool to detect SHA-1 collision";
    longDescription = ''
      This library and command line tool were designed as near drop-in
      replacements for common SHA-1 libraries and sha1sum. They will
      compute the SHA-1 hash of any given file and additionally will
      detect cryptanalytic collision attacks against SHA-1 present in
      each file. It is very fast and takes less than twice the amount
      of time as regular SHA-1.
      '';
    platforms = platforms.all;
    maintainers = with maintainers; [ leenaars ];
    license = licenses.mit;
  };
}
