{ stdenv, fetchurl, pkgconfig, gnutls, liburcu, lmdb, libcap_ng, libidn2, libunistring
, systemd, nettle, libedit, zlib, libiconv, libintl
}:

let inherit (stdenv.lib) optional optionals; in

# Note: ATM only the libraries have been tested in nixpkgs.
stdenv.mkDerivation rec {
  pname = "knot-dns";
  version = "2.8.5";

  src = fetchurl {
    url = "https://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "f8b04bb2eba562163a73abb58f616975b56db9b52fb981d22963f639538ba38e";
  };

  outputs = [ "bin" "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gnutls liburcu libidn2 libunistring
    nettle libedit
    libiconv lmdb libintl
    # without sphinx &al. for developer documentation
  ]
    ++ optionals stdenv.isLinux [ libcap_ng systemd ]
    ++ optional stdenv.isDarwin zlib; # perhaps due to gnutls

  enableParallelBuilding = true;

  CFLAGS = [ "-O2" "-DNDEBUG" ];

  doCheck = true;
  doInstallCheck = false; # needs pykeymgr?

  postInstall = ''rm -r "$out"/var "$out"/lib/*.la'';

  meta = with stdenv.lib; {
    description = "Authoritative-only DNS server from .cz domain registry";
    homepage = https://knot-dns.cz;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.vcunat ];
  };
}
