{ lib, fetchurl, appimageTools }:
let
  name = "saleae-logic-2";
  version = "2.3.33";
  src = fetchurl {
    url = "https://downloads.saleae.com/logic2/Logic-${version}-master.AppImage";
    sha256 = "09vypl03gj58byk963flskzkhl4qrd9qw1kh0sywbqnzbzvj5cgm";
  };
in
appimageTools.wrapType2 {
  inherit name src;

  extraInstallCommands =
    let appimageContents = appimageTools.extractType2 { inherit name src; }; in
    ''
      mkdir -p $out/etc/udev/rules.d
      cp ${appimageContents}/resources/linux/99-SaleaeLogic.rules $out/etc/udev/rules.d/
    '';

  meta = with lib; {
    homepage = "https://www.saleae.com/";
    description = "Software for Saleae logic analyzers";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.j-hui ];
  };
}
