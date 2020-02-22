{ stdenv
, fetchFromGitHub
, cmake
, mbedtls
, fuse
}:


stdenv.mkDerivation rec {
  pname = "dislocker";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "aorimn";
    repo = "dislocker";
    rev = "v${version}";
    sha256 = "1crh2sg5x1kgqmdrl1nmrqwxjykxa4zwnbggcpdn97mj2gvdw7sb";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ fuse mbedtls ];

  meta = with stdenv.lib; {
    description = "Read BitLocker encrypted partitions in Linux";
    homepage    = https://github.com/aorimn/dislocker;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ elitak ];
    platforms   = platforms.linux;
  };
}
