{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "mawk";
  version = "1.3.4-20240123";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/mawk/mawk-${version}.tgz"
      "https://invisible-mirror.net/archives/mawk/mawk-${version}.tgz"
    ];
    sha256 = "sha256-qOMZqDdEsfH7aYjfoYnWGIf4ZukUDMmknrADsrBlXog=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  meta = with lib; {
    description = "Interpreter for the AWK Programming Language";
    mainProgram = "mawk";
    homepage = "https://invisible-island.net/mawk/mawk.html";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ehmry ];
    platforms = with platforms; unix;
  };
}
