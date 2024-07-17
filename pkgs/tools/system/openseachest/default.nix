{
  lib,
  fetchFromGitHub,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "openseachest";
  version = "23.12";

  src = fetchFromGitHub {
    owner = "Seagate";
    repo = "openSeaChest";
    rev = "v${version}";
    hash = "sha256-2snxruIC/93+yI7g/9cCXcms8FaoXnoyWq9py8GTwrs=";
    fetchSubmodules = true;
  };

  makeFlags = [ "-C Make/gcc" ];
  buildFlags = [ "release" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r Make/gcc/openseachest_exes/. $out/bin
    cp -r docs/man $out/share

    runHook postInstall
  '';

  meta = with lib; {
    description = "Collection of command line diagnostic tools for storage devices";
    homepage = "https://github.com/Seagate/openSeaChest";
    license = licenses.mpl20;
    maintainers = with maintainers; [ justinas ];
    platforms = with platforms; freebsd ++ linux;
  };
}
