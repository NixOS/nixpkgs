{
  lib
, writeShellScriptBin
, symlinkJoin
, xu4
}:

let
  ultima4 = builtins.fetchurl {
    url = "https://archive.org/download/msdos_Ultima_IV_-_Quest_of_the_Avatar_1985/Ultima_IV_-_Quest_of_the_Avatar_1985.zip";
    sha256 = "sha256:162cafvayzb0zxs0j5ximvlzbdknahhvic5fk7mhmi1zcj0d5gkb";
  };
  upgrade = builtins.fetchurl {
    url = "https://bitbucket.org/mcmagi/ultima-exodus/downloads/u4upgrade-1.3.zip";
    sha256 = "sha256:0n6abhi82j0gbf38c98nym3b3lpan9hnb0ypnb0p9gpk25rw62j0";
  };
  launchScript = "ultima4";
  launch = writeShellScriptBin launchScript ''
    mkdir -p ~/.local/share/xu4
    ln -sf ${ultima4} ~/.local/share/xu4/ultima4.zip
    ln -sf ${upgrade} ~/.local/share/xu4/u4upgrad.zip
    ${xu4}/bin/xu4 $@
  '';
in
symlinkJoin rec {
  pname = "ultima-xu4";
  version = "1.3";

  name = "${pname}-${version}";

  paths = [ launch ];

  meta = with lib; {
    description = "Role-playing video game";
    homepage = "https://en.wikipedia.org/wiki/Ultima_IV:_Quest_of_the_Avatar";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = xu4.meta.platforms;
    maintainers = with maintainers; [ mausch ];
    mainProgram = launchScript;
  };
}
