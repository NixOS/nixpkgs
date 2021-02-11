{ lib, stdenv, fetchurl, php }:

stdenv.mkDerivation rec {
  version = "4.8.0";
  pname = "adminer";

  # not using fetchFromGitHub as the git repo relies on submodules that are included in the tar file
  src = fetchurl {
    url = "https://github.com/vrana/adminer/releases/download/v${version}/adminer-${version}.tar.gz";
    sha256 = "sha256-T2LEUoIbFrMta+wP7PNci0QkFYrJZmWP3RP/JzgqUoc=";
  };

  nativeBuildInputs = [
    php
    php.packages.composer
  ];

  buildPhase = ''
    runHook preBuild

    composer --no-cache run compile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp adminer-${version}.php $out/adminer.php

    runHook postInstall
  '';

  meta = with lib; {
    description = "Database management in a single PHP file";
    homepage = "https://www.adminer.org";
    license = with licenses; [ asl20 gpl2Only ];
    maintainers = with maintainers; [
      jtojnar
      sstef
    ];
    platforms = platforms.all;
  };
}
