{
  lib,
  stdenv,
  fetchurl,
  coreutils,
}:

stdenv.mkDerivation rec {
  pname = "entr";
  version = "5.5";

  src = fetchurl {
    url = "https://eradman.com/entrproject/code/${pname}-${version}.tar.gz";
    hash = "sha256-EowM4u/qWua9P9M8PNMeFh6wwCYJ2HF6036VtBZW5SY=";
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
    maintainers = with maintainers; [
      pSub
      synthetica
    ];
    mainProgram = "entr";
  };
}
