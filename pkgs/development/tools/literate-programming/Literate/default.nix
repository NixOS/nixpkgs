{ lib, stdenv, fetchgit, ldc, dub }:

stdenv.mkDerivation {
  pname = "Literate";
  version = "unstable-2021-01-22";

  src = fetchgit {
    url = "https://github.com/zyedidia/Literate.git";
    rev = "7004dffec0cff3068828514eca72172274fd3f7d";
    sha256 = "0x4xgrdskybaa7ssv81grmwyc1k167v3nwj320jvp5l59xxlbcvs";
  };

  buildInputs = [ ldc dub ];

  installPhase = "install -D bin/lit $out/bin/lit";

  meta = with lib; {
    description = "A literate programming tool for any language";
    homepage    = "http://literate.zbyedidia.webfactional.com/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
