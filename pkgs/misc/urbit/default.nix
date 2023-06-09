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
  version = "2.8";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-reU8i7++VdAiuH36AyfhZhAJPnE4t0nBnYvWoglrKwA=";
      aarch64-linux = "sha256-l3190BUIeJVbQI1tfP8W6WHw6WyfoYpI8rnjbgevznk=";
      x86_64-darwin = "sha256-tsBuIcbWiK1oyu9UzHfwJe/nsVrLWXzoX/eIHyg4uaU=";
      aarch64-darwin = "sha256-f+C5DB+IeN6ZcZ4oES4dc3LQ4pwDDszffu/U/KFwqmg=";
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
