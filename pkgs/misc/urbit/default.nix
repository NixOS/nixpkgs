{ stdenv
, lib
, fetchzip
}:

let
  os = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
stdenv.mkDerivation rec {
  pname = "urbit";
  version = "2.11";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-k2zmcjZ9NXmwZf93LIAg1jx4IRprKUgdkvwzxEOKWDY=";
      aarch64-linux = "sha256-atMBXyXwavpSDTZxUnXIq+NV4moKGRWLaFTM9Kuzt94=";
      x86_64-darwin = "sha256-LSJ9jVY3fETlpRAkyUWa/2vZ5xAFmmMssvbzUfIBY/4=";
      aarch64-darwin = "sha256-AViUt2N+YCgMWOcv3ZI0GfdYVOiRLbhseQ7TTq4zCiQ=";
    }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  postInstall = ''
    install -m755 -D vere-v${version}-${platform} $out/bin/urbit
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = with lib; {
    homepage = "https://urbit.org";
    description = "An operating function";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    maintainers = [ maintainers.matthew-levan ];
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
