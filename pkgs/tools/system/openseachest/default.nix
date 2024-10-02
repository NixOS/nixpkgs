{ lib
, fetchFromGitHub
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "openseachest";
  version = "24.08.1";

  src = fetchFromGitHub {
    owner = "Seagate";
    repo = "openSeaChest";
    rev = "v${version}";
    hash = "sha256-1vfWX6uTQcM6K6wu9Ygu2xZV4nXm6VnwNHmQ2ceh62s=";
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
