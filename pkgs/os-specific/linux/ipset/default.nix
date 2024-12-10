{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libmnl,
}:

stdenv.mkDerivation rec {
  pname = "ipset";
  version = "7.21";

  src = fetchurl {
    url = "https://ipset.netfilter.org/${pname}-${version}.tar.bz2";
    sha256 = "sha256-4sbOT886yziTyl01yGk1+ArXb8XMrmARhYQt92DgvGk=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libmnl ];

  configureFlags = [ "--with-kmod=no" ];

  meta = with lib; {
    homepage = "https://ipset.netfilter.org/";
    description = "Administration tool for IP sets";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
