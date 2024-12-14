{
  stdenv,
  lib,
  fetchzip,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "macos" else "linux";
  arch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
stdenv.mkDerivation rec {
  pname = "urbit";
  version = "3.1";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 =
      {
        x86_64-linux = "sha256-51Zgv9QANQVMk/dc7/heYmCNfeu4k7mrYNke1/oz/94=";
        aarch64-linux = "sha256-Tdn/ve9iCjsY/b39TZ7ErHV14mIAHdtmycgUPIzRihQ=";
        x86_64-darwin = "sha256-y/FQIVcEn6dLWXPztC34+7+5eDMO7Xcx25D2+0p7Mxk=";
        aarch64-darwin = "sha256-YJGRZlpTdm1x4P+GnZiKC1411tcEX+Jdnm+iyxUlsU0=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  postInstall = ''
    install -m755 -D vere-v${version}-${platform} $out/bin/urbit
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = with lib; {
    homepage = "https://urbit.org";
    description = "Operating function";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ maintainers.matthew-levan ];
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "urbit";
  };
}
