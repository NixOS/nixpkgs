{ lib, stdenv, libressl, fetchzip, fetchpatch, pkg-config }:

stdenv.mkDerivation rec {
  pname = "pounce";
  version = "2.1p1";

  src = fetchzip {
    url = "https://git.causal.agency/pounce/snapshot/pounce-${version}.tar.gz";
    sha256 = "1gphia45swj4ws6nrklqg1hvjrc6yw921v0pf29cvjhwrfl6dl0h";
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
