{ lib, stdenv, fetchFromGitHub
, autoreconfHook
, pkgconfig
, snappy
}:

stdenv.mkDerivation rec {
  pname = "snzip";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "kubo";
    repo = "snzip";
    rev = version;
    sha256 = "1v8li1zv9f2g31iyi9y9zx42rjvwkaw221g60pmkbv53y667i325";
  };

  buildInputs = [ snappy ];
  # We don't use a release tarball so we don't have a `./configure` script to
  # run. That's why we generate it.
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  meta = with stdenv.lib; {
    description = "A compression/decompression tool based on snappy";
    homepage = "https://github.com/kubo/snzip";
    maintainers = with maintainers; [ doronbehar ];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}

