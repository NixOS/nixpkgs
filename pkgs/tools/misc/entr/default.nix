{ lib, stdenv, fetchurl, coreutils }:

stdenv.mkDerivation rec {
  pname = "entr";
<<<<<<< HEAD
  version = "5.4";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/${pname}-${version}.tar.gz";
    hash = "sha256-SR3e0sw/Hc2NJvSWpMezqZa5HHqyCIPKN1A3o5giH54=";
=======
  version = "5.2";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/${pname}-${version}.tar.gz";
    hash = "sha256-I34wnUawdSEMDky3ib/Qycd37d9sswNBw/49vMZYw4A=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace entr.c --replace /bin/cat ${coreutils}/bin/cat
    substituteInPlace entr.1 --replace /bin/cat cat
  '';
  dontAddPrefix = true;
  doCheck = true;
  checkTarget = "test";
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://eradman.com/entrproject/";
    description = "Run arbitrary commands when files change";
    changelog = "https://github.com/eradman/entr/raw/${version}/NEWS";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub synthetica ];
  };
}
