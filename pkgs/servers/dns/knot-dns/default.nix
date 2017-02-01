{ stdenv, fetchurl, pkgconfig, gnutls, jansson, liburcu, lmdb, libcap_ng, libidn
, systemd, nettle, libedit, zlib, libiconv, fetchpatch
}:

# Note: ATM only the libraries have been tested in nixpkgs.
stdenv.mkDerivation rec {
  name = "knot-dns-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "http://secure.nic.cz/files/knot-dns/knot-${version}.tar.xz";
    sha256 = "0y9nhp9lfmxv4iy1xg7l4lfxv4168qhag26wwg0dbi0zjpkd790b";
  };

  patches = stdenv.lib.optional stdenv.isDarwin
      (fetchpatch {
        name = "before-sierra.diff";
        url = "https://gitlab.labs.nic.cz/labs/knot/merge_requests/664.diff";
        sha256 = "0g4gm2m3pi0lfpkp53xayf6jq6yn3ifidh40maiy1a46dfadvw6w";
      });

  outputs = [ "bin" "out" "dev" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gnutls jansson liburcu libidn
    nettle libedit
    libiconv
    # without sphinx &al. for developer documentation
  ]
    # Use embedded lmdb there for now, as detection is broken on Darwin somehow.
    ++ stdenv.lib.optionals stdenv.isLinux [ libcap_ng systemd lmdb ]
    ++ stdenv.lib.optional stdenv.isDarwin zlib; # perhaps due to gnutls

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

