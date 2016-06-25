{ stdenv, fetchFromGitHub
, cmake
, polarssl , fuse
}:
with stdenv.lib;
let
  version = "0.6.1";
in
stdenv.mkDerivation rec {
  name = "dislocker-${version}";

  src = fetchFromGitHub {
    owner = "aorimn";
    repo = "dislocker";
    rev = "v${version}";
    sha256 = "1s2pvsf4jgzxk9d9m2ik7v7g81lvj8mhmhh7f53vwy0vmihf9h0d";
  };

  buildInputs = [ cmake fuse polarssl ];

  patches = [ ./cmake_dirfix.patch ];

  meta = {
    description = "Read BitLocker encrypted partitions in Linux";
    homepage    = https://github.com/aorimn/dislocker;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ elitak ];
    platforms   = platforms.linux;
  };
}
