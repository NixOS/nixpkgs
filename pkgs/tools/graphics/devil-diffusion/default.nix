{ buildFHSEnv, runCommand, callPackage, fetchurl, stdenv, bash, makeDesktopItem, copyDesktopItems, }:

let
    devil-diffusion = stdenv.mkDerivation rec {
        name = "Devil-Diffusion";
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


    install -m755 -D DevilUI/ComfyUI-devil/devil-Comfy-CUDA.sh $out/bin
    install -m755 -D DevilUI/ComfyUI-devil/devil-Comfy-CPU.sh $out/bin
    install -m755 -D DevilUI/ComfyUI-devil/devil-Comfy-AMD.sh $out/bin

    install -m755 -D DevilUI/stable-diffusion-webui-1.10.1/devil-automaticUI-CUDA.sh $out/bin
    install -m755 -D DevilUI/stable-diffusion-webui-1.10.1/devil-automaticUI-CPU.sh $out/bin
    install -m755 -D DevilUI/stable-diffusion-webui-1.10.1/devil-automaticUI-AMD.sh $out/bin




    install -m755 -D DevilUI/devil-diffusion-icon.png $out/share/icons/hicolor/1024x1024/apps
    install -m755 -D DevilUI/devil-diffusion-icon.png $out/share/pixmaps


    runHook postInstall
  '';
devil-Comfy-AMD = makeDesktopItem rec { #### AMD
  name = "Devil Diffusion Comfy AMD";
  exec = "devil-Comfy-AMD.sh";
  icon = "devil-diffusion-icon.ico";
  terminal = true;
  desktopName = "Devil Diffusion Comfy AMD";
  categories = [ "Development" ];
};
devil-Comfy-CPU = makeDesktopItem rec { #### CPU

  name = "Devil Diffusion Comfy CPU";
  exec = "devil-Comfy-CPU.sh";
  icon = "devil-diffusion-icon.ico";
  terminal = true;
  desktopName = "Devil Diffusion Comfy CPU";
  categories = [ "Development" ];
};
devil-Comfy-CUDA = makeDesktopItem rec { #### CUDA


  name = "Devil Diffusion Comfy CUDA";
  exec = "devil-Comfy-CUDA.sh";
  icon = "devil-diffusion-icon.ico";
  terminal = true;
  desktopName = "Devil Diffusion Comfy CUDA";
  categories = [ "Development" ];
};
devil-automaticUI-AMD = makeDesktopItem rec { #### AMD





  name = "Devil Diffusion automaticUI AMD";
  exec = "devil-automaticUI-AMD.sh";
  icon = "devil-diffusion-icon.ico";
  terminal = true;
  desktopName = "Devil Diffusion automaticUI AMD";
  categories = [ "Development" ];
};
devil-automaticUI-CPU = makeDesktopItem rec { #### CPU


  name = "Devil Diffusion automaticUI CPU";
  exec = "devil-automaticUI-CPU.sh";
  icon = "devil-diffusion-icon.ico";
  terminal = true;
  desktopName = "Devil Diffusion automaticUI CPU";
  categories = [ "Development" ];
};
devil-automaticUI-CUDA = makeDesktopItem rec { #### CUDA


  name = "Devil Diffusion automaticUI CUDA";
  exec = "devil-automaticUI-CUDA.sh";
  icon = "devil-diffusion-icon.ico";
  terminal = true;
  desktopName = "Devil Diffusion automaticUI CUDA";
  categories = [ "Development" ];
};};

in

 buildFHSEnv rec {
    name = "Devil-Diffusion-env";
#    runScript = "";


    targetPkgs = pkgs: [devil-diffusion];}
