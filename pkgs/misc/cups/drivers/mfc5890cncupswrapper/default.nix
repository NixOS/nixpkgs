{
  lib,
  findutils,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  coreutils,
  gnugrep,
  gnused,
  mfc5890cnlpr,
  pkgsi686Linux,
  psutils,
}:

stdenv.mkDerivation rec {
  pname = "mfc5890cncupswrapper";
  version = "1.1.2-2";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf006170/${pname}-${version}.i386.deb";
    hash = "sha256-UOCwzB09/a1/2rliY+hTrslSvO5ztVj51auisPx7OIQ=";
  };

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    lpr=${mfc5890cnlpr}/usr/local/Brother/Printer/mfc5890cn
    dir=$out/usr/local/Brother/Printer/mfc5890cn

    interpreter=${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" "$dir/cupswrapper/brcupsconfpt1"

    #comment out lpadmin commands to prohibit changes to CUPS config by just installing this driver.
    substituteInPlace $dir/cupswrapper/cupswrappermfc5890cn \
      --replace "lpadmin" "#lpadmin" \
      --replace "/usr/" "$out/usr/"

    #mfc5890cnlpr is a dependency of this package. Link all files of mfc5890cnlpr into the $out/usr folder, as other scripts depend on these files being present.
    #Ideally, we would use substituteInPlace for each file this package actually requires. But the scripts of Brother use variables to dynamically build the paths
    #at runtime, making this approach more complex. Hence, the easier route of simply linking all files was choosen.
    find "$lpr" -type f -exec sh -c "mkdir -vp \$(echo '{}' | sed 's|$lpr|$dir|g' | xargs dirname) && ln -s '{}' \$(echo '{}' | sed 's|$lpr|$dir|g')" \;

    mkdir -p $out/usr/share/ppd/
    mkdir -p $out/usr/lib64/cups/filter
    sed -i '941,972d' $dir/cupswrapper/cupswrappermfc5890cn
    $dir/cupswrapper/cupswrappermfc5890cn

    chmod +x $out/usr/lib64/cups/filter/brlpdwrappermfc5890cn
    wrapProgram $out/usr/lib64/cups/filter/brlpdwrappermfc5890cn --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        psutils
        gnugrep
        gnused
      ]
    }

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model
    ln $out/usr/lib64/cups/filter/brlpdwrappermfc5890cn $out/lib/cups/filter
    ln $dir/cupswrapper/cupswrappermfc5890cn $out/lib/cups/filter
    ln $out/usr/share/ppd/brmfc5890cn.ppd $out/share/cups/model
  '';

  meta = with lib; {
    description = "Brother MFC-5890CN CUPS wrapper driver.";
    longDescription = "Brother MFC-5890CN CUPS wrapper driver. Use the connection string 'lpd://\${IP_ADDRESS}/binary_p1' when connecting to this printer via the network.";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ martinramm ];
  };
}
