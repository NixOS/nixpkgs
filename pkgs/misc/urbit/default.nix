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
  version = "2.3";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-7rPkEgJdCDkfz58VYOH2AH6s/048pySpmff0tfRkPqU=";
      aarch64-linux = "sha256-8P0BNyaV+VxS2cl3ac2Ey7YC1b2A+DbfZZVpaI3agJw=";
      x86_64-darwin = "sha256-EHYr3lG2WeHaFjO7CNcz5Ygv5MYzuFcCoX36hEXZVoo=";
      aarch64-darwin = "sha256-lPuavLA73NtMC/yS/L1XwPljPnWw+9mcrw4RrqbVrnA=";
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
