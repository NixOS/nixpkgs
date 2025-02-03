{ buildFHSEnv, runCommand, callPackage, fetchurl, stdenv, bash, makeDesktopItem, copyDesktopItems, writeShellScript, }:


let
    Devil-Diffusion-AMD-ComfyUI = stdenv.mkDerivation rec {
        pname = "devil-diffusion-AMD-ComfyUI";
        name = pname;
        src = fetchurl {
        url = "https://github.com/Mephist0phel3s/Devil-Diffusion/archive/refs/tags/ef0ce16.tar.gz";
        hash = "sha256-Fs5ZH/+TpnID8bbD/vMROFq9cbTnm3FNab7OPBUUEd0=";
        };




  unpackPhase = false;
  sourceRoot = ".";
  dontConfigure = true;
  buildPhase = false;
  dontBuild = true;
  nativeBuildInputs = [bash copyDesktopItems];
    installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/pixmaps
    cd Devil-Diffusion-ef0ce16
    echo "where am i"
    echo $PWD
    echo "whats here?"
    ls -al DevilUI

    cp -r DevilUI/ComfyUI-devil $out/bin
    install -m755 -D DevilUI/ComfyUI-devil/devil-Comfy-CUDA.sh $out/bin
    install -m755 -D DevilUI/ComfyUI-devil/devil-Comfy-CPU.sh $out/bin
    install -m755 -D DevilUI/ComfyUI-devil/devil-Comfy-AMD.sh $out/bin


    install -m755 -D DevilUI/devil-diffusion-icon.png $out/share/icons/hicolor/1024x1024/apps
    install -m755 -D DevilUI/devil-diffusion-icon.png $out/share/pixmaps

    runHook postInstall
  '';


};


in

 buildFHSEnv rec {
    name = "Devil-Diffusion-env";
    runScript = "devil-Comfy-AMD.sh" ;
    targetPkgs = pkgs: [Devil-Diffusion-AMD-ComfyUI];}



#  meta = with lib; {
#    description = "Stable Diffusion Devil, Nixified";

#    homepage = "";
#    license = licenses.unlicense;
#    platforms = platforms.linux;
#    maintainers = with maintainers; [ adam248 ];
