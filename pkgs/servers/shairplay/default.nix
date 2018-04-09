{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, avahi, libao }:

stdenv.mkDerivation rec {
  name = "shairplay-${version}";
  version = "2016-01-01";

  src = fetchFromGitHub {
    owner  = "juhovh";
    repo   = "shairplay";
    rev    = "ce80e005908f41d0e6fde1c4a21e9cb8ee54007b";
    sha256 = "10b4bmqgf4rf1wszvj066mc42p90968vqrmyqyrdal4k6f8by1r6";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ avahi libao ];

  enableParallelBuilding = true;

  # the build will fail without complaining about a reference to /tmp
  preFixup = stdenv.lib.optionalString stdenv.isLinux ''
    patchelf \
      --set-rpath "${stdenv.lib.makeLibraryPath buildInputs}:$out/lib" \
      $out/bin/shairplay
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Apple airplay and raop protocol server";
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
