{ stdenv, lib, fetchFromGitHub, cmake, git, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "verovio";
  version = "3.12.1";

  src = fetchFromGitHub {
    owner = "rism-digital";
    repo = pname;
    rev = "version-${version}";
    sha256 = "sha256-1Tv9wHx4bu1NH0rG4Bsc0oa7eeWcWrkmJ3VnV9cjPxg=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ cmake git makeWrapper ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    set -exo pipefail

    cd tools
    patchShebangs .
    cmake ../cmake
    make -j 8

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/

    mv verovio $out/bin
    cp -R $src/data $out/share/verovio

    wrapProgram $out/bin/verovio \
      --add-flags "-r $out/share/verovio"

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = ''
      A fast, portable and lightweight library for engraving Music Encoding Initiative (MEI) digital scores into SVG images.
    '';
    homepage = "https://www.verovio.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tshaynik ];
    platforms = platforms.all;
  };
}
