{ lib, stdenv, fetchFromGitHub, zlib, bzip2, lzfse, pkg-config }:

stdenv.mkDerivation rec {
  version = "1.1.0";
  pname = "undmg";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "undmg";
    rev = "v${version}";
    sha256 = "0rb4h89jrl04vwf6p679ipa4mp95hzmc1ca11wqbanv3xd1kcpxm";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zlib bzip2 lzfse ];

  setupHook = ./setup-hook.sh;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/matthewbauer/undmg";
    description = "Extract a DMG file";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ matthewbauer lnl7 ];
    mainProgram = "undmg";
  };
}
