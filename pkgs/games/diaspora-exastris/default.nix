{ lib
, alsa-lib
, fetchzip
, libXxf86vm
, makeWrapper
, openjdk
, stdenv
, xorg
, copyDesktopItems
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "diaspora-exastris";
  version = "1.00.11";

  src = fetchzip {
    url = "http://diaspora-exastris.com/wp-content/uploads/2022/10/diaspora-${version}.tar.gz";
    sha256 = "sha256-ADdaMChzV+XAPtNaOqdEvUgRU1yLO+FF1YN3yuPpZk0=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];
  buildInputs = with xorg; [
    alsa-lib
    libXxf86vm
  ];

  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = "diaspora-exastris";
      exec = "diaspora-exastris";
      icon = "diaspora-exastris";
      comment = meta.description;
      genericName = "diaspora-exastris";
      desktopName = "Diaspora-Exastris";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r ./* $out

    wrapProgram $out/diaspora.sh \
      --prefix PATH : ${lib.makeBinPath [ openjdk ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --chdir "$out"
    ln -s $out/diaspora.sh $out/bin/diaspora-exastris

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace diaspora.sh \
      --replace "diaspora_out.log" "/tmp/diaspora_out.log" \
      --replace "diaspora_err.log" "/tmp/diaspora_err.log"
  '';

  meta = with lib; {
    description = "A sandbox space-based single-player strategy game set in the future";
    homepage = "https://diaspora-exastris.com";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ bbigras ];
    changelog = "https://diaspora-exastris.com/development/";
  };
}
