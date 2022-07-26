{ stdenv, lib, fetchurl, dpkg, autoPatchelfHook, dbus }:

stdenv.mkDerivation rec {
  pname = "cloudflare-warp";
  version = "2022.02.24";

  src = fetchurl {
    url = "https://pkg.cloudflareclient.com/uploads/cloudflare_warp_2022_2_288_1_amd64_a0be7b47b3.deb";
    sha256 = "sha256-gBXF0EfFMT6BC6ts/6PQYJH3AAQSDsFoZGK3RZIqmOA=";
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
    mv lib $out
    mv bin $out

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/warp-svc.service \
      --replace "ExecStart=" "ExecStart=$out"
  '';

  meta = with lib; {
    description = "Replaces the connection between your device and the Internet with a modern, optimized, protocol";
    homepage = "https://pkg.cloudflareclient.com/packages/cloudflare-warp";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
