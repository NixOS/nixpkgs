{ stdenv, requireFile, lib,
  libcxx, libcxxabi
}:

stdenv.mkDerivation rec {
  pname = "blackmagic-desktop-video";
  major = "12.0";
  version = "${major}a14";

  buildInputs = [
    libcxx libcxxabi
  ];

  src = requireFile {
    name = "Blackmagic_Desktop_Video_Linux_${major}.tar.gz";
    url = "https://www.blackmagicdesign.com/support/download/76b2edbed5884e1dbbfea104071f1643/Linux";
    sha256 = "e5a586ee705513cf5e6b024e1ec68621ab91d50b370981023e0bff73a19169c2";
  };

  setSourceRoot = ''
    tar xf Blackmagic_Desktop_Video_Linux_${major}/other/x86_64/desktopvideo-${version}-x86_64.tar.gz
    sourceRoot=$NIX_BUILD_TOP/desktopvideo-${version}-x86_64
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/doc,lib}
    cp -r $sourceRoot/usr/share/doc/desktopvideo $out/share/doc
    cp $sourceRoot/usr/lib/*.so $out/lib
    ln -s ${libcxx}/lib/* ${libcxxabi}/lib/* $out/lib
    cp $sourceRoot/usr/lib/blackmagic/DesktopVideo/libgcc_s.so.1 $out/lib/
    cp $sourceRoot/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper $out/bin/

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
    description = "Supporting applications for Blackmagic Decklink. Doesn't include the desktop applications, only the helper required to make the driver work.";
    platforms = platforms.linux;
  };
}
