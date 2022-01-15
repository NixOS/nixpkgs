{ stdenv, lib, fetchurl, p7zip }:

stdenv.mkDerivation rec {
  pname = "7zz";
  version = "21.07";

  src = fetchurl {
    url = "https://7-zip.org/a/7z${lib.replaceStrings [ "." ] [ "" ] version}-src.7z";
    sha256 = "sha256-0QdNVvQVqrmdmeWXp7ZtxFXbpjSa6KTInfdkdbahKEw=";
  };

  sourceRoot = "CPP/7zip/Bundles/Alone2";

  # we need https://github.com/nidud/asmc/tree/master/source/asmc/linux in order
  # to build with the optimized assembler but that doesn't support building with
  # GCC: https://github.com/nidud/asmc/issues/8
  makefile = "../../cmpl_gcc.mak"; # "../../cmpl_gcc_x64.mak";

  nativeBuildInputs = [ p7zip ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin b/g/7zz
    install -Dm444 -t $out/share/doc/${pname} ../../../../DOC/*.txt

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/7zz --help | grep ${version}
  '';

  meta = with lib; {
    description = "Command line archiver utility";
    homepage = "https://7zip.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ anna328p peterhoeg ];
    platforms = platforms.linux;
  };
}
