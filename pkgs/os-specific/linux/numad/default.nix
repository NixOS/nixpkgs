{
  lib,
  stdenv,
  fetchgit,
}:

stdenv.mkDerivation rec {
  pname = "numad";
  version = "0.5";

  src = fetchgit {
    url = "https://pagure.io/numad.git";
    rev = "334278ff3d774d105939743436d7378a189e8693";
    sha256 = "sha256-6nrbfooUI1ufJhsPf68li5584oKQcznXQlxfpStuX5I=";
  };

  hardeningDisable = [ "format" ];

  patches = [
    ./numad-linker-flags.patch
  ];
  postPatch = ''
    substituteInPlace Makefile --replace "install -m" "install -Dm"
  '';

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "A user-level daemon that monitors NUMA topology and processes resource consumption to facilitate good NUMA resource access";
    mainProgram = "numad";
    homepage = "https://fedoraproject.org/wiki/Features/numad";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
