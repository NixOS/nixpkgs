{ stdenv, lib, fetchurl, dpkg, autoPatchelfHook, dbus }:

stdenv.mkDerivation rec {
  pname = "cloudflare-warp";
  version = "2022.7.421";

  src = fetchurl {
    #https://pkg.cloudflareclient.com/packages/cloudflare-warp Ubuntu Focal amd64
    url = "https://pkg.cloudflareclient.com/pool/dists/focal/main/cloudflare_warp_2022_7_472_1_amd64_77aa79eba3_amd64.deb";
    sha256 = "sha256-lbT3uH0kUbFpSvEYcfdh5jnpaKINwXotD3iePwXHAsY=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [ dbus ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    runHook preInstall

    mv usr $out
    cp -a lib $out && rm -rf lib
    mv bin $out

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/warp-svc.service \
      --replace "ExecStart=" "ExecStart=$out"
    substituteInPlace $out/lib/systemd/user/warp-taskbar.service \
      --replace "ExecStart=" "ExecStart=$out"
  '';

  meta = with lib; {
    description = "Replaces the connection between your device and the Internet with a modern, optimized, protocol";
    homepage = "https://pkg.cloudflareclient.com/packages/cloudflare-warp";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang astevenstaylor ];
    platforms = [ "x86_64-linux" ];
  };
}
