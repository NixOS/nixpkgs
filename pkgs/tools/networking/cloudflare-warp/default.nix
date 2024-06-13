{ stdenv
, lib
, autoPatchelfHook
, copyDesktopItems
, dbus
, dpkg
, fetchurl
, gtk3
, libpcap
, makeDesktopItem
, makeWrapper
, nftables
}:

stdenv.mkDerivation rec {
  pname = "cloudflare-warp";
  version = "2024.4.133";

  suffix = {
    aarch64-linux = "arm64";
    x86_64-linux = "amd64";
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://pkg.cloudflareclient.com/pool/jammy/main/c/cloudflare-warp/cloudflare-warp_${version}-1_${suffix}.deb";
    hash = {
      aarch64-linux = "sha256-qua+aL4+yvpTBGCVUS1rzJX1KZ3DeaW9Bce9lYWvWOM=";
      x86_64-linux = "sha256-xZhyYDMjcv8SLfYwclvWBqPDETbeaxiA6jFCg3Nv5gc=";
    }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    dbus
    gtk3
    libpcap
    stdenv.cc.cc.lib
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "com.cloudflare.WarpCli";
      desktopName = "Cloudflare Zero Trust Team Enrollment";
      categories = [ "Utility" "Security" "ConsoleOnly" ];
      noDisplay = true;
      mimeTypes = [ "x-scheme-handler/com.cloudflare.warp" ];
      exec = "warp-cli teams-enroll-token %u";
      startupNotify = false;
      terminal = true;
    })
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libpcap.so.0.8"
  ];

  installPhase = ''
    runHook preInstall

    mv usr $out
    mv bin $out
    mv etc $out
    patchelf --replace-needed libpcap.so.0.8 ${libpcap}/lib/libpcap.so $out/bin/warp-dex
    mv lib/systemd/system $out/lib/systemd/
    substituteInPlace $out/lib/systemd/system/warp-svc.service \
      --replace "ExecStart=" "ExecStart=$out"
    substituteInPlace $out/lib/systemd/user/warp-taskbar.service \
      --replace "ExecStart=" "ExecStart=$out"

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/warp-svc --prefix PATH : ${lib.makeBinPath [ nftables ]}
  '';

  meta = with lib; {
    description = "Replaces the connection between your device and the Internet with a modern, optimized, protocol";
    homepage = "https://pkg.cloudflareclient.com/packages/cloudflare-warp";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    mainProgram = "warp-cli";
    maintainers = with maintainers; [
      wolfangaukang
      devpikachu
      marcusramberg
    ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
