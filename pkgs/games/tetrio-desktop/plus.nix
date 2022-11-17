{ fetchzip
, tetrio-desktop
, lib
}:

let
  version = "0.23.13";
  patchedAsar = fetchzip {
    url = "https://gitlab.com/UniQMG/tetrio-plus/uploads/a9647feffc484304ee49c4d3fd4ce718/tetrio-plus_0.23.13_app.asar.zip";
    sha256 = "sha256-NSOVZjm4hDXH3f0gFG8ijLmdUTyMRFYGhxpwysoYIVg=";
  };
in tetrio-desktop.overrideAttrs (old: {
  pname = "tetrio-plus-desktop";
  version = old.version + "+${version}";

  installPhase = old.installPhase + ''
    cp ${patchedAsar}/app.asar $out/opt/TETR.IO/resources
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/UniQMG/tetrio-plus";
    downloadPage = "https://gitlab.com/UniQMG/tetrio-plus/-/releases";
    description = "TETR.IO PLUS desktop client";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [ Enzime ];
    mainProgram = "tetrio-desktop";
  };
})
