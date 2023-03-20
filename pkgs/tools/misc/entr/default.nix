{ lib, stdenv, fetchurl, coreutils }:

stdenv.mkDerivation rec {
  pname = "entr";
  version = "5.2";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/${pname}-${version}.tar.gz";
    hash = "sha256-I34wnUawdSEMDky3ib/Qycd37d9sswNBw/49vMZYw4A=";
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
