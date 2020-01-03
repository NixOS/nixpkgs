{ stdenv, fetchpatch, fetchFromGitHub, pkgconfig, autoreconfHook
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
, cppunit, sphinx
, Security
}:

stdenv.mkDerivation rec {
  pname = "aria2";
  version = "1.35.0";

  src = fetchFromGitHub {
    owner = "aria2";
    repo = "aria2";
    rev = "release-${version}";
    sha256 = "195r3711ly3drf9jkygwdc2m7q99hiqlfrig3ip1127b837gzsf9";
  };

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
    maintainers = with maintainers; [ filalex77 koral ];
  };
}
