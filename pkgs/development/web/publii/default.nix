{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, makeShellWrapper
, wrapGAppsHook
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, cairo
, cups
, dbus
, expat
, glib
, gtk3
, libsecret
, mesa
, nss
, pango
, udev
, xdg-utils
, xorg
}:

stdenv.mkDerivation rec {
  pname = "publii";
  version = "0.44.1";

  src = fetchurl {
    url = "https://getpublii.com/download/Publii-${version}.deb";
    hash = "sha256-jpEVn7Suv/mNdbxwnjmOMvMJizJLQCeE+aFbmprE52g=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeShellWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libsecret
    mesa
    nss
    pango
    xorg.libX11
    xorg.libxcb
  ];

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    mv usr/share $out
    substituteInPlace $out/share/applications/Publii.desktop \
      --replace 'Exec=/opt/Publii/Publii' 'Exec=Publii'

    mv opt $out

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper $out/opt/Publii/Publii $out/bin/Publii \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}
  '';

  meta = with lib; {
    description = "Static Site CMS with GUI to build privacy-focused SEO-friendly website.";
    longDescription = ''
      Creating a website doesn't have to be complicated or expensive. With Publii, the most
      intuitive static site CMS, you can create a beautiful, safe, and privacy-friendly website
      quickly and easily; perfect for anyone who wants a fast, secure website in a flash.
    '';
    homepage = "https://getpublii.com";
    changelog = "https://github.com/getpublii/publii/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ urandom sebtm ];
    platforms = [ "x86_64-linux" ];
  };
}
