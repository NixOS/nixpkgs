{ stdenv, fetchFromGitHub, parted, utillinux, pkg-config }:

stdenv.mkDerivation rec {

  version = "1.1.0";
  pname = "fatresize";

  src = fetchFromGitHub {
    owner = "ya-mouse";
    repo = "fatresize";
    rev = "v${version}";
    sha256 = "1vhz84kxfyl0q7mkqn68nvzzly0a4xgzv76m6db0bk7xyczv1qr2";
  };

  buildInputs = [ parted utillinux ];
  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ parted utillinux ];

  meta = with stdenv.lib; {
    description = "The FAT16/FAT32 non-destructive resizer";
    homepage = "https://github.com/ya-mouse/fatresize";
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
