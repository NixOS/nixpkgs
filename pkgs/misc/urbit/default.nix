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
  version = "2.10";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-Bf0XDuGSBq8z9zouPQJyi/ZPEE6RzXb9+HCls89MR8Q=";
      aarch64-linux = "sha256-Ecmc41X4AM3xigBvJGyWkIFxXM3vy+uK9p2M93UUJiY=";
      x86_64-darwin = "sha256-eQSbzcP612LxOxdj9THPzyLtJwAthygjsSSct7vk1fc=";
      aarch64-darwin = "sha256-VIXD8WHwAgRCLDZg1H5KmuiIqQMziWR6/4XxvSYtmTs=";
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
