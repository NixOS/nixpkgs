{ stdenv, libressl, fetchzip, fetchpatch, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pounce";
  version = "1.4p2";

  src = fetchzip {
    url = "https://git.causal.agency/pounce/snapshot/pounce-${version}.tar.gz";
    sha256 = "0fpnj9yvmj4gbbfpya4i0lyin56r782pz19z3pgd8xgs22gd48cc";
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
