{ stdenv, lib, fetchurl, p7zip, uasm, useUasm ? stdenv.isx86_64 }:

let
  inherit (stdenv.hostPlatform) system;
  platformSuffix =
    if useUasm then
      {
        x86_64-linux = "_x64";
      }.${system} or (throw "`useUasm` is not supported for system ${system}")
    else "";
in
stdenv.mkDerivation rec {
  pname = "7zz";
  version = "21.07";

  src = fetchurl {
    url = "https://7-zip.org/a/7z${lib.replaceStrings [ "." ] [ "" ] version}-src.7z";
    sha256 = "sha256-0QdNVvQVqrmdmeWXp7ZtxFXbpjSa6KTInfdkdbahKEw=";
  };

  sourceRoot = "CPP/7zip/Bundles/Alone2";

  makeFlags = lib.optionals useUasm [ "MY_ASM=uasm" ];

  makefile = "../../cmpl_gcc${platformSuffix}.mak";

  nativeBuildInputs = [ p7zip ] ++ lib.optionals useUasm [ uasm ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin b/g${platformSuffix}/7zz
    install -Dm444 -t $out/share/doc/${pname} ../../../../DOC/*.txt

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/7zz --help | grep ${version}
  '';

  meta = with lib; {
    description = "Command line archiver utility";
    homepage = "https://7-zip.org";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ anna328p peterhoeg ];
    platforms = platforms.linux;
  };
}
