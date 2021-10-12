{ lib, stdenv, libressl, fetchzip, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pounce";
  version = "2.5";

  src = fetchzip {
    url = "https://git.causal.agency/pounce/snapshot/pounce-${version}.tar.gz";
    sha256 = "0swbncsm888r95dwk13v1vii5sr3gah817dfah5v7zs8lsv1kgv5";
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
