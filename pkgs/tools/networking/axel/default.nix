{ lib, stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive
, pkg-config, gettext, libssl, txt2man }:

stdenv.mkDerivation rec {
  pname = "axel";
  version = "2.17.10";

  src = fetchFromGitHub {
    owner = "axel-download-accelerator";
    repo = pname;
    rev = "v${version}";
    sha256 = "01mpfkz98r2fx4n0gyi3b4zvlyfd5bxydp2wh431lnj0ahrsiikp";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config autoconf-archive txt2man ];

  buildInputs = [ gettext libssl ];

  installFlags = [ "ETCDIR=${placeholder "out"}/etc" ];

  meta = with lib; {
    description = "Console downloading program with some features for parallel connections for faster downloading";
    homepage = "https://github.com/axel-download-accelerator/axel";
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
    license = licenses.gpl2;
  };
}
