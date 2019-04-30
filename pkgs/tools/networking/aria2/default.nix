{ stdenv, fetchpatch, fetchFromGitHub, pkgconfig, autoreconfHook
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
, cppunit, sphinx
, Security
}:

stdenv.mkDerivation rec {
  name = "aria2-${version}";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "aria2";
    repo = "aria2";
    rev = "release-${version}";
    sha256 = "0hwqnjyszasr6049vr5mn48slb48v5kw39cbpbxa68ggmhj9bw6m";
  };

  patches = [
    # Remove with 1.35.0.
    (fetchpatch {
      url = https://github.com/aria2/aria2/commit/e8e04d6f22a507e8374651d3d2343cd9fb986993.patch;
      sha256 = "1v27nqbsdjgg3ga4n0v9daq21m3cmdpy7d08kp32200pzag87f4y";
    })
  ];

  nativeBuildInputs = [ pkgconfig autoreconfHook sphinx ];

  buildInputs = [ openssl c-ares libxml2 sqlite zlib libssh2 ] ++
    stdenv.lib.optional stdenv.isDarwin Security;

  configureFlags = [ "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt" ];

  prePatch = ''
    patchShebangs doc/manual-src/en/mkapiref.py
  '';

  checkInputs = [ cppunit ];
  doCheck = false; # needs the net

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://aria2.github.io;
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ koral ];
  };
}
