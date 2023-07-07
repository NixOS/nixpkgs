{ lib
, fetchFromGitHub
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "openseachest";
  version = "23.03.1";

  src = fetchFromGitHub {
    owner = "Seagate";
    repo = "openSeaChest";
    rev = "v${version}";
    sha256 = "sha256-jDCCozHeOazB3cM/9TlwHq1pu7yTiD818jykHeQ+RBo=";
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
    description = "A collection of command line diagnostic tools for storage devices";
    homepage = "https://github.com/Seagate/openSeaChest";
    license = licenses.mpl20;
    maintainers = with maintainers; [ justinas ];
    platforms = with platforms; freebsd ++ linux;
  };
}
