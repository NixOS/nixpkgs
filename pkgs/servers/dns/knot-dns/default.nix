{ stdenv, fetchurl, pkgconfig, gnutls, liburcu, lmdb, libcap_ng, libidn
, systemd, nettle, libedit, zlib, libiconv, libintlOrEmpty
}:

let inherit (stdenv.lib) optional optionals; in

# Note: ATM only the libraries have been tested in nixpkgs.
stdenv.mkDerivation rec {
  name = "knot-dns-${version}";
  version = "2.6.3";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "2fb27a4006865fc12873cbadc5b4a870ec65d3293a284972c031522282987790";
  };

  outputs = [ "bin" "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gnutls liburcu libidn
    nettle libedit
    libiconv lmdb
    # without sphinx &al. for developer documentation
  ]
    ++ optionals stdenv.isLinux [ libcap_ng systemd ]
    ++ libintlOrEmpty
    ++ optional stdenv.isDarwin zlib; # perhaps due to gnutls

  enableParallelBuilding = true;

  CFLAGS = [ "-O2" "-DNDEBUG" ];

  #doCheck = true; problems in combination with dynamic linking

  postInstall = ''rm -r "$out"/var'';

  meta = with stdenv.lib; {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = https://knot-dns.cz;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}

