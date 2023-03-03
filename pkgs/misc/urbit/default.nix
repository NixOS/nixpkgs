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
  version = "1.22";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-wYXFromLV1BCiSWlzphtCSBOWacQ3yC7i2kxxH4y88Y=";
      aarch64-linux = "sha256-t3waCv2hwkchWPlfx1bsKKB6imp7F6scRnZUQSwS6fI=";
      x86_64-darwin = "sha256-x5Gr6z5ma+0AF7DEXJpqG+yg3ym+w2ULTqfpdLjfHGo=";
      aarch64-darwin = "sha256-vvGZoN+Yi6FZDblhxwDzRneVtWaFFaOjyRG7017BzZI=";
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
  };
}
