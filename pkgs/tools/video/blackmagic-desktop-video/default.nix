{ stdenv, requireFile, lib,
  libcxx, libcxxabi
}:

stdenv.mkDerivation rec {
  pname = "blackmagic-desktop-video";
  version = "12.0a14";

  buildInputs = [
    libcxx libcxxabi
  ];

  src = requireFile {
    name = "Blackmagic_Desktop_Video_Linux_${lib.versions.majorMinor version}.tar.gz";
    url = "https://www.blackmagicdesign.com/support/download/76b2edbed5884e1dbbfea104071f1643/Linux";
    sha256 = "e5a586ee705513cf5e6b024e1ec68621ab91d50b370981023e0bff73a19169c2";
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
