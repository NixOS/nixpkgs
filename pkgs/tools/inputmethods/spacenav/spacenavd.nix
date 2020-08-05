{ stdenv
, fetchFromGitHub
, xorg 
}:

stdenv.mkDerivation rec {
  pname = "spacenavd";
  version = "0.7.1";
  src = fetchFromGitHub {
    owner = "FreeSpacenav";
    repo = pname;
    rev = "v${version}";
    sha256 = "1k7jrm0xp6zmf7j72nnbqb54vs7qj08arx4xa0v99ra2369q88ii";
  };
  buildInputs = [ xorg.libX11 ];
}

