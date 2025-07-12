{
  lib,
  mkTclDerivation,
  fetchFromGitHub,
  lmdb,
}:

mkTclDerivation rec {
  pname = "tcl-lmdb";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ray2501";
    repo = "tcl-lmdb";
    rev = version;
    hash = "sha256-HrR8VQ9cE9jkESqvKkLnYbZLErUVxau2z8xcFImH9lc=";
  };

  configureFlags = [
    "--with-system-lmdb=yes"
  ];

  buildInputs = [
    lmdb
  ];

  meta = {
    description = "The Tcl interface to the Lightning Memory-Mapped Database";
    homepage = "https://github.com/ray2501/tcl-lmdb";
    changelog = "https://github.com/ray2501/tcl-lmdb/blob/master/ChangeLog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
}
