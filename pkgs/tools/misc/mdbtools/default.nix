{ stdenv, lib, fetchFromGitHub, glib, readline
, bison, flex, pkg-config, autoreconfHook, libxslt, makeWrapper
, txt2man, which
}:

stdenv.mkDerivation rec {
  pname = "mdbtools";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "mdbtools";
    repo = "mdbtools";
    rev = "v${version}";
    sha256 = "sha256-Hnub8h0a3qx5cxVn1tp/IVbz9aORjGGWizD3Z4rPl2s=";
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
