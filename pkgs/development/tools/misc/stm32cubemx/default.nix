{ stdenv, requireFile, makeDesktopItem, libicns, imagemagick, zstd, jre }:

let
  version = "5.3.0";
  desktopItem = makeDesktopItem {
    name = "stm32CubeMX";
    exec = "stm32cubemx";
    desktopName = "STM32CubeMX";
    categories = "Application;Development;";
    icon = "stm32cubemx";
  };
in
stdenv.mkDerivation rec {
  pname = "stm32cubemx";
  inherit version;

  src = requireFile rec {
    name = "STM32CubeMX.tar.zst";
    message = ''
      Unfortunately, we cannot download file ${name} automatically.
      Please proceed with the following steps to download and add it to the Nix
      store yourself:

      1. get en.STM32CubeMX_${builtins.replaceStrings ["."] ["-"] version}.zip
      2. unzip en.STM32CubeMX_${builtins.replaceStrings ["."] ["-"] version}.zip
      3. run the setup: java -jar SetupSTM32CubeMX-${version}.exe
      4. create a tar from created folder: tar --zstd -cf ${name} STM32CubeMX
      5. add the result to the store: nix-prefetch-url file://\$PWD/${name}

      Notice: The setup will quit with an error about /bin/chmod
    '';
    sha256 = "1r5k5wmsvw1w2nfs3nb4gc6pb3j0x6bqljn9jzc4r8y5bxc34rr8";
  };

  nativeBuildInputs = [ libicns imagemagick zstd ];

  buildCommand = ''
    mkdir -p $out/{bin,opt,share/applications}

    tar --extract --zstd --file $src --directory $out/opt/
    chmod +rx $out/opt/STM32CubeMX/STM32CubeMX.exe

    cat << EOF > $out/bin/${pname}
    #!${stdenv.shell}
    ${jre}/bin/java -jar $out/opt/STM32CubeMX/STM32CubeMX.exe
    EOF
    chmod +x $out/bin/${pname}

    icns2png --extract $out/opt/STM32CubeMX/${pname}.icns
    ls
    for size in 16 24 32 48 64 128 256; do
      mkdir -pv $out/share/icons/hicolor/"$size"x"$size"/apps
      if [ -e ${pname}_"$size"x"$size"x32.png ]; then
        mv ${pname}_"$size"x"$size"x32.png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
      else
        convert -resize "$size"x"$size" ${pname}_256x256x32.png \
          $out/share/icons/hicolor/"$size"x"$size"/apps/${pname}.png
      fi
    done;

    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = with stdenv.lib; {
    description = ''
      A graphical tool that allows a very easy configuration of STM32
      microcontrollers and microprocessors, as well as the generation of the
      corresponding initialization C code for the Arm® Cortex®-M core or a
      partial Linux® Device Tree for Arm® Cortex®-A core), through a
      step-by-step process.        
    '';
    homepage = "https://www.st.com/en/development-tools/stm32cubemx.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.all;
  };
}
