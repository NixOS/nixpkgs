{ stdenv
, cacert
, curl
, runCommandLocal
, lib
, autoPatchelfHook
, libcxx
, libGL
, gcc7
}:

stdenv.mkDerivation rec {
  pname = "blackmagic-desktop-video";
  version = "12.5a15";

  buildInputs = [
    autoPatchelfHook
    libcxx
    libGL
    gcc7.cc.lib
  ];

  # yes, the below download function is an absolute mess.
  # blame blackmagicdesign.
  src = runCommandLocal "${pname}-${lib.versions.majorMinor version}-src.tar.gz"
    rec {
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-ss7Ab5dy7cmXp9LBirFXMeGY4ZbYHvWnXmYvNeBq0RY=";

      impureEnvVars = lib.fetchers.proxyImpureEnvVars;

      nativeBuildInputs = [ curl ];

      # ENV VARS
      SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

      # from the URL that the POST happens to, see browser console
      DOWNLOADID = "fecacc0f9b2f4c2e8bf2863e9e26c8e1";
      # from the URL the download page where you click the "only download" button is at
      REFERID = "052d944af6744608b27da496dfc4396d";
      SITEURL = "https://www.blackmagicdesign.com/api/register/us/download/${DOWNLOADID}";

      USERAGENT = builtins.concatStringsSep " " [
        "User-Agent: Mozilla/5.0 (X11; Linux ${stdenv.hostPlatform.linuxArch})"
        "AppleWebKit/537.36 (KHTML, like Gecko)"
        "Chrome/77.0.3865.75"
        "Safari/537.36"
      ];

      REQJSON = builtins.toJSON {
        "country" = "nl";
        "downloadOnly" = true;
        "platform" = "Linux";
        "policy" = true;
      };

    } ''
    RESOLVEURL=$(curl \
      -s \
      -H "$USERAGENT" \
      -H 'Content-Type: application/json;charset=UTF-8' \
      -H "Referer: https://www.blackmagicdesign.com/support/download/$REFERID/Linux" \
      --data-ascii "$REQJSON" \
      --compressed \
      "$SITEURL")

    curl \
      --retry 3 --retry-delay 3 \
      --compressed \
      "$RESOLVEURL" \
      > $out
  '';

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
    cp $unpacked/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper $out/bin/

    substituteInPlace $out/lib/systemd/system/DesktopVideoHelper.service --replace "/usr/lib/blackmagic/DesktopVideo/DesktopVideoHelper" "$out/bin/DesktopVideoHelper"

    runHook postInstall
  '';

  # i know this is ugly, but it's the cleanest way i found to tell the DesktopVideoHelper where to find its own library
  appendRunpaths = [ "$ORIGIN/../lib" ];

  meta = with lib; {
    homepage = "https://www.blackmagicdesign.com/support/family/capture-and-playback";
    maintainers = [ maintainers.hexchen ];
    license = licenses.unfree;
    description = "Supporting applications for Blackmagic Decklink. Doesn't include the desktop applications, only the helper required to make the driver work";
    platforms = platforms.linux;
  };
}
