{ lib, stdenv, libressl, fetchzip, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pounce";
  version = "2.3";

  src = fetchzip {
    url = "https://git.causal.agency/pounce/snapshot/pounce-${version}.tar.gz";
    sha256 = "0pk3kwr6k6dz2vdx1kyv7mhj756j4bwsmdlmjzhh8ghczjqp2s2x";
  };

  buildInputs = [ libressl ];

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
