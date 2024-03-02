{ fetchgit, lib, stdenv }:

stdenv.mkDerivation (finalAttrs: {
  pname = "gendef";
  version = "11.0.1";

  src = fetchgit {
    url = "https://git.code.sf.net/p/mingw-w64/mingw-w64.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0vbAHSN+uwxoXXZtbuycP67PxjcB8Ftxd/Oij1gqE3Y=";
  };

  sourceRoot = "mingw-w64/mingw-w64-tools/gendef";

  meta = {
    description = "A tool which generate def files from DLLs";
    homepage = "https://sourceforge.net/p/mingw-w64/wiki2/gendef/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.linux;
  };
})
