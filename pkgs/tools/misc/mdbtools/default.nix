{ stdenv, lib, fetchFromGitHub, glib, readline
, bison, flex, pkg-config, autoreconfHook, libxslt, makeWrapper
, txt2man, which
}:

stdenv.mkDerivation rec {
  pname = "mdbtools";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "mdbtools";
    repo = "mdbtools";
    rev = "v${version}";
    sha256 = "11cv7hh8j8akpgm1a6pp7im6iacpgx6wzcg9n9rmb41j0fgxamdf";
  };

  configureFlags = [ "--disable-scrollkeeper" ];

  nativeBuildInputs = [
    pkg-config bison flex autoreconfHook txt2man which
  ];

  buildInputs = [ glib readline ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = ".mdb (MS Access) format tools";
    license = with licenses; [ gpl2 lgpl2 ];
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    inherit (src.meta) homepage;
  };
}
