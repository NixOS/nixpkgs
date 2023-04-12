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
  version = "2.1";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-i5WofHC0aYldnA+KldeAmZQQo6yeI3yhmLHqPZOvi1c=";
      aarch64-linux = "sha256-QRarT+BtVPX7yURsqABZXcYyzqMGweIzo/MGpC2HhEo=";
      x86_64-darwin = "sha256-JuMjYwmcArPEjcUapdkSu9FEFKK4ZfxJxmvRVOJ3w34=";
      aarch64-darwin = "sha256-5lpBhmdDpNVFHZ7P6TRBoFWFWKvwbJNO6ohiuoKMc6E=";
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
