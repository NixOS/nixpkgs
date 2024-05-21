{ lib, stdenv, libressl, fetchzip, pkg-config, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "pounce";
  version = "3.1";

  src = fetchzip {
    url = "https://git.causal.agency/pounce/snapshot/pounce-${version}.tar.gz";
    sha256 = "sha256-6PGiaU5sOwqO4V2PKJgIi3kI2jXsBOldEH51D7Sx9tg=";
  };

  buildInputs = [ libressl libxcrypt ];

  nativeBuildInputs = [ pkg-config ];

  buildFlags = [ "all" ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with lib; {
    homepage = "https://code.causal.agency/june/pounce";
    description = "Simple multi-client TLS-only IRC bouncer";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edef ];
  };
}
