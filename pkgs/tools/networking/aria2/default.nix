{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook
, openssl, c-ares, libxml2, sqlite, zlib, libssh2
, cppunit, sphinx
, Security
}:

stdenv.mkDerivation rec {
  pname = "aria2";
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "aria2";
    repo = "aria2";
    rev = "release-${version}";
    sha256 = "sha256-ErjFfSJDIgZq0qy0Zn5uZ9bZS2AtJq4FuBVuUuQgPTI=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config autoreconfHook sphinx ];

  buildInputs = [ openssl c-ares libxml2 sqlite zlib libssh2 ] ++
    lib.optional stdenv.isDarwin Security;

  outputs = [ "bin" "dev" "out" "doc" "man" ];

  configureFlags = [
    "--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt"
    "--enable-libaria2"
    "--with-bashcompletiondir=${placeholder "bin"}/share/bash-completion/completions"
  ];

  prePatch = ''
    patchShebangs --build doc/manual-src/en/mkapiref.py
  '';

  checkInputs = [ cppunit ];
  doCheck = false; # needs the net

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://aria2.github.io";
    description = "A lightweight, multi-protocol, multi-source, command-line download utility";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ Br1ght0ne koral ];
  };
}
