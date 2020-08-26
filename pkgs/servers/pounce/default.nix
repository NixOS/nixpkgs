{ stdenv, libressl, fetchzip, fetchpatch, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pounce";
  version = "1.3p1";

  src = fetchzip {
    url = "https://git.causal.agency/pounce/snapshot/pounce-${version}.tar.gz";
    sha256 = "1ab4pz7gyvlms00hcarcmsljkn0whwqxfck8b343l4riai2rj9xv";
  };

  buildInputs = [ libressl ];

  nativeBuildInputs = [ pkg-config ];

  buildFlags = [ "all" ];

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = with stdenv.lib; {
    homepage = "https://code.causal.agency/june/pounce";
    description = "Simple multi-client TLS-only IRC bouncer";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edef ];
  };
}
