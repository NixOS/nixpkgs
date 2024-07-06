{ lib, stdenv, fetchgit, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "numad";
  version = "0-unstable-2023-09-06";

  src = fetchgit {
    url = "https://pagure.io/numad.git";
    rev = "3399d89305b6560e27e70aff4ad9fb403dedf947";
    sha256 = "sha256-USEffVcakaAbilqijJmpro92ujvxbglcXxyBlntMxaI=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "install -m" "install -Dm"
  '';

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A user-level daemon that monitors NUMA topology and processes resource consumption to facilitate good NUMA resource access";
    mainProgram = "numad";
    homepage = "https://fedoraproject.org/wiki/Features/numad";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
