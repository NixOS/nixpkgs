{ stdenv, fetchFromGitHub
, cmake
, polarssl , fuse
}:
with stdenv.lib;
let
  version = "0.7.1";
in
stdenv.mkDerivation {
  pname = "dislocker";
  inherit version;

  src = fetchFromGitHub {
    owner = "aorimn";
    repo = "dislocker";
    rev = "v${version}";
    sha256 = "1crh2sg5x1kgqmdrl1nmrqwxjykxa4zwnbggcpdn97mj2gvdw7sb";
  };

  buildInputs = [ cmake fuse polarssl ];

  meta = {
    description = "Read BitLocker encrypted partitions in Linux";
    homepage    = https://github.com/aorimn/dislocker;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ elitak ];
    platforms   = platforms.linux;
  };
}
