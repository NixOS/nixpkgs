{ stdenv, requireFile, makeDesktopItem, libicns, imagemagick, jre, fetchzip }:

let
  version = "5.6.1";
  desktopItem = makeDesktopItem {
    name = "stm32CubeMX";
    exec = "stm32cubemx";
    desktopName = "STM32CubeMX";
    categories = "Development;";
    icon = "stm32cubemx";
  };
in
stdenv.mkDerivation rec {
  pname = "stm32cubemx";
  inherit version;


  src = fetchzip {
    url = "https://sw-center.st.com/packs/resource/library/stm32cube_mx_v${builtins.replaceStrings ["."] [""] version}.zip";
    sha256 = "1y4a340wcjl88kjw1f1x85ffp4b5g1psryn9mgkd717w2bfpf29l";
    stripRoot= false;
  };

  nativeBuildInputs = [ libicns imagemagick ];

  buildCommand = ''
    mkdir -p $out/{bin,opt/STM32CubeMX,share/applications}
    cp -r $src/. $out/opt/STM32CubeMX/
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
    description = "A graphical tool for configuring STM32 microcontrollers and microprocessors";
    longDescription = ''
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
