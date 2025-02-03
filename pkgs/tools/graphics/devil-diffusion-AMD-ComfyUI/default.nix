{ buildFHSEnv, runCommand, callPackage, fetchurl, stdenv, bash, makeDesktopItem, copyDesktopItems, writeShellScript, }:


let
    Devil-Diffusion-AMD-ComfyUI = stdenv.mkDerivation rec {
        pname = "devil-diffusion-AMD-ComfyUI";
        name = pname;
        version = "ec810ad";
        src = fetchurl {
        url = "https://github.com/Mephist0phel3s/Devil-Diffusion/archive/refs/tags/${version}.tar.gz";
        hash = "sha256-BItgMEw/gr4rmeFY2jx5zYtK4oKVg1wBAGFqixuDF2w=";
        };




  unpackPhase = false;
  sourceRoot = ".";
  dontConfigure = true;
  buildPhase = false;
  dontBuild = true;
  nativeBuildInputs = [bash copyDesktopItems];
    installPhase = let
      desktopItem = makeDesktopItem {
        name = "Devil Diffusion";
        exec = "${pname}/bin/devil-Comfy-AMD.sh";
        desktopName = "Devil Diffusion Comfy AMD";
        categories = [ "Development" ];
        icon = "devil-diffusion-icon.icon";
        terminal = true;

      }; in ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/pixmaps
    echo "where i be?"
    echo $PWD/
    cd Devil-Diffusion-${version}
    ls -al
    echo "where am i"
    echo $PWD
    echo "whats here?"
    ls -al DevilUI
    cp -r DevilUI/ComfyUI-devil/* $out/
    ln -s $out/devil-Comfy-CUDA.sh $out/bin
    ln -s $out/devil-Comfy-CPU.sh $out/bin
    ln -s $out/devil-Comfy-AMD.sh $out/bin

    install -m755 -D $out/devil-diffusion-icon.icon $out/share/icons/hicolor/1024x1024/apps/devil-diffusion-icon.png
    install -m755 -D $out/devil-diffusion-icon.icon $out/share/pixmaps/devil-diffusion-icon.png

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
