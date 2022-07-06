{ stdenv, lib, fetchzip, autoPatchelfHook, ... }:

let
  name = "authelia";
  pname = "${name}-bin";
  version = "4.36.2";

  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  platform = {
    x86_64-linux = "linux-amd64";
    aarch64-linux = "linux-arm64";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-linux = "l7VKO28mcGqho2WiMzvRSmQ9PZaKKZs+vLOigVhqCjk=";
    aarch64-linux = "8oQlGjaiLTuWq9KR4TQQYs3QZmK4pZlm/Omcpu/h/Yo=";
  }.${system} or throwSystem;
in
stdenv.mkDerivation {
  inherit pname;
  inherit version;

  src = fetchzip {
    url = "https://github.com/${name}/${name}/releases/download/v${version}/${name}-v${version}-${platform}.tar.gz";
    inherit sha256;
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    install -m 755 -D ${name}-${platform} $out/bin/authelia
  '';

  meta = with lib; {
    homepage = "https://www.authelia.com/";
    description = "The Single Sign-On Multi-Factor portal for web apps";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
