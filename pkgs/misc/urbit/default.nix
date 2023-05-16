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
<<<<<<< HEAD
  version = "2.11";
=======
  version = "2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
<<<<<<< HEAD
      x86_64-linux = "sha256-k2zmcjZ9NXmwZf93LIAg1jx4IRprKUgdkvwzxEOKWDY=";
      aarch64-linux = "sha256-atMBXyXwavpSDTZxUnXIq+NV4moKGRWLaFTM9Kuzt94=";
      x86_64-darwin = "sha256-LSJ9jVY3fETlpRAkyUWa/2vZ5xAFmmMssvbzUfIBY/4=";
      aarch64-darwin = "sha256-AViUt2N+YCgMWOcv3ZI0GfdYVOiRLbhseQ7TTq4zCiQ=";
=======
      x86_64-linux = "sha256-7rPkEgJdCDkfz58VYOH2AH6s/048pySpmff0tfRkPqU=";
      aarch64-linux = "sha256-8P0BNyaV+VxS2cl3ac2Ey7YC1b2A+DbfZZVpaI3agJw=";
      x86_64-darwin = "sha256-EHYr3lG2WeHaFjO7CNcz5Ygv5MYzuFcCoX36hEXZVoo=";
      aarch64-darwin = "sha256-lPuavLA73NtMC/yS/L1XwPljPnWw+9mcrw4RrqbVrnA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
