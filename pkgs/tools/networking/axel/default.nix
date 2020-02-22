{ stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive
, pkgconfig, gettext, libssl, txt2man }:

stdenv.mkDerivation rec {
  pname = "axel";
  version = "2.17.7";

  src = fetchFromGitHub {
    owner = "axel-download-accelerator";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z20d2fkf69v35d4pkba95vnk7yq7393kwikmb64y7cjyz4m2ngk";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig autoconf-archive txt2man ];

  buildInputs = [ gettext libssl ];

  installFlags = [ "ETCDIR=${placeholder "out"}/etc" ];

  meta = with stdenv.lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = "https://github.com/axel-download-accelerator/axel";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
    license = licenses.gpl2;
  };
}
