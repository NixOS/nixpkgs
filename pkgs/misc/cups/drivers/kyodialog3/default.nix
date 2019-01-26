{ stdenv, lib, fetchzip, cups, autoPatchelfHook

  # Can either be "EU" or "Global"; it's unclear what the difference is
  , region ? "Global", qt4
}:

let
  platform =
    if stdenv.hostPlatform.system == "x86_64-linux" then "64bit"
    else if stdenv.hostPlatform.system == "i686-linux" then "32bit"
         else throw "Unsupported system: ${stdenv.hostPlatform.system}";
  debPlatform =
    if platform == "64bit" then "amd64"
    else "i386";
  debRegion = if region == "EU" then "EU." else "";
in
stdenv.mkDerivation rec {
  name = "cups-kyodialog3-${version}";
  version = "8.1601";

  dontStrip = true;

  src = fetchzip {
    url = "https://usa.kyoceradocumentsolutions.com/content/dam/kdc/kdag/downloads/technical/executables/drivers/kyoceradocumentsolutions/us/en/Kyocera_Linux_PPD_Ver_${version}.tar.gz";
    sha256 = "11znnlkfssakml7w80gxlz1k59f3nvhph91fkzzadnm9i7a8yjal";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ cups qt4 ];

  installPhase = ''
    mkdir -p $out
    cd $out

    # unpack the debian archive
    ar p ${src}/KyoceraLinuxPackages/${region}/${platform}/kyodialog3.en${debRegion}_0.5-0_${debPlatform}.deb data.tar.gz | tar -xz
    rm -Rf KyoceraLinuxPackages

    # strip $out/usr
    mv usr/* .
    rmdir usr

    # allow cups to find the ppd files
    mkdir -p share/cups/model
    mv share/ppd/kyocera share/cups/model/Kyocera
    rmdir share/ppd

    # prepend $out to all references in ppd and desktop files
    find -name "*.ppd" -exec sed -E -i "s:/usr/lib:$out/lib:g" {} \;
    find -name "*.desktop" -exec sed -E -i "s:/usr/lib:$out/lib:g" {} \;
  '';

  meta = with lib; {
    description = "CUPS drivers for several Kyocera printers";
    homepage = "https://www.kyoceradocumentsolutions.com";
    license = licenses.unfree;
    maintainers = [ maintainers.steveej ];
    platforms = platforms.linux;
  };
}
