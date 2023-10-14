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
  version = "2.12";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-N8RYlafw0HcmtGAQMKQb1cG7AivOpWS/5rU8CESJWAw=";
      aarch64-linux = "sha256-RsBtwxSdqHVXMk7or1nPAFWd6Ypa0SqjpTihv8riyk4=";
      x86_64-darwin = "sha256-/QPI66/gl3mlQHc+8zrEyP4/Hv5vwXlEx1cW2mP33IY=";
      aarch64-darwin = "sha256-+2DYohaBxVcR1ZOjuk6GWcNpzb6aJMXq6BxwWw1OeIY=";
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
