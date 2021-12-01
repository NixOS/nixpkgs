{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, gnutls, libite, libconfuse }:

stdenv.mkDerivation rec {
  pname = "inadyn";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "troglobit";
    repo = "inadyn";
    rev = "v${version}";
    sha256 = "sha256-kr9xh7HMikargi0hhj3epH2c6R5lN4qD9nDaChNI4Kg=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ gnutls libite libconfuse ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://troglobit.com/project/inadyn/";
    description = "Free dynamic DNS client";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
