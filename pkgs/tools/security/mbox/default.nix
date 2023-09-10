{ lib, stdenv, fetchFromGitHub, openssl, which }:

stdenv.mkDerivation {
  pname = "mbox";
  version = "unstable-2014-05-26";

  src = fetchFromGitHub {
    owner = "tsgates";
    repo = "mbox";
    rev = "a131424b6cb577e1c916bd0e8ffb2084a5f73048";
    sha256 = "06qggqxnzcxnc34m6sbafxwr2p64x65m9zm5wp7pwyarcckhh2hd";
  };

  buildInputs = [ openssl which ];

  preConfigure = ''
    cd src
    cp {.,}configsbox.h
  '';

  doCheck = true;
  checkPhase = ''
    rm tests/test-*vim.sh tests/test-pip.sh

    patchShebangs ./; dontPatchShebags=1
    sed -i 's|^/bin/||' tests/test-fileops.sh

    ./testall.sh
  '';

  meta = with lib;    {
    description = "Lightweight sandboxing mechanism that any user can use without special privileges";
    homepage = "http://pdos.csail.mit.edu/mbox/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    broken = true;
  };
}
