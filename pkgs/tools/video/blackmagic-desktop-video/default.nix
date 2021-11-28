{ stdenv, requireFile, lib,
  libcxx, libcxxabi
}:

stdenv.mkDerivation rec {
  pname = "blackmagic-desktop-video";
  version = "12.2a12";

  buildInputs = [
    libcxx libcxxabi
  ];

  src = requireFile {
    name = "Blackmagic_Desktop_Video_Linux_${lib.versions.majorMinor version}.tar.gz";
    url = "https://www.blackmagicdesign.com/support/download/33abc1034cd54cf99101f9acd2edd93d/Linux";
    sha256 = "62954a18b60d9040aa4a959dff30ac9c260218ef78d6a63cbb243788f7abc05f";
  };

  postUnpack = ''
    tar xf Blackmagic_Desktop_Video_Linux_${lib.versions.majorMinor version}/other/${stdenv.hostPlatform.uname.processor}/desktopvideo-${version}-${stdenv.hostPlatform.uname.processor}.tar.gz
    unpacked=$NIX_BUILD_TOP/desktopvideo-${version}-${stdenv.hostPlatform.uname.processor}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/doc,lib/systemd/system}
    cp -r $unpacked/usr/share/doc/desktopvideo $out/share/doc
    cp $unpacked/usr/lib/*.so $out/lib
    cp $unpacked/usr/lib/systemd/system/DesktopVideoHelper.service $out/lib/systemd/system
    ln -s ${libcxx}/lib/* ${libcxxabi}/lib/* $out/lib
    cp $unpacked/usr/lib/blackmagic/DesktopVideo/libgcc_s.so.1 $out/lib/
    cp $unpacked/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper $out/bin/

    substituteInPlace $out/lib/systemd/system/DesktopVideoHelper.service --replace "/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper" "$out/bin/DesktopVideoHelper"

    runHook postInstall
  '';


  postFixup = ''
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      --set-rpath "$out/lib:${lib.makeLibraryPath [ libcxx libcxxabi ]}" \
      $out/bin/DesktopVideoHelper
  '';

  meta = with lib; {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    maintainers = [ maintainers.hexchen ];
    license = licenses.unfree;
    description = "Supporting applications for Blackmagic Decklink. Doesn't include the desktop applications, only the helper required to make the driver work";
    platforms = platforms.linux;
  };
}
