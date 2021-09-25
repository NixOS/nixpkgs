{ appimageTools, lib, fetchurl }:
let
  pname = "mathpix-snipping-tool";
  version = "03.00.0050";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://download.mathpix.com/linux/Mathpix_Snipping_Tool-x86_64.v${version}.AppImage";
    sha256 = "0bf4x6jffiqdss8vwy1qypv75zxi1bfc8rywsgp5qlsjq792plpb";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications

    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "OCR tool to convert pictures to LaTeX.";
    homepage = "https://mathpix.com/";
    license = licenses.unfree;
    maintainers = [ maintainers.hiro98 ];
    platforms = [ "x86_64-linux" ];
  };
}
