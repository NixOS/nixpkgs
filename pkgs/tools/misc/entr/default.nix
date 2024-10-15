{ lib, stdenv, fetchurl, coreutils }:

stdenv.mkDerivation rec {
  pname = "entr";
  version = "5.6";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/entr-${version}.tar.gz";
    hash = "sha256-AiK435KNO1o7UZTWPn3gmFM+BBkNnZoVS5JsbB+d0U4=";
  };

  postPatch = ''
    substituteInPlace entr.c --replace /bin/cat ${coreutils}/bin/cat
    substituteInPlace entr.1 --replace /bin/cat cat
  '';
  dontAddPrefix = true;
  doCheck = true;
  checkTarget = "test";
  installFlags = [ "PREFIX=$(out)" ];

  TARGET_OS = stdenv.hostPlatform.uname.system;

  meta = with lib; {
    homepage = "https://eradman.com/entrproject/";
    description = "Run arbitrary commands when files change";
    changelog = "https://github.com/eradman/entr/raw/${version}/NEWS";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub synthetica ];
    mainProgram = "entr";
  };
}
