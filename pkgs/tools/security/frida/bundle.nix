{ lib
, stdenv
, name
, version
, hash
, fetchurl

, autoPatchelfHook
, python3
}:

let
  isToolchian = name == "toolchain";

  system = {
    aarch64-linux = "linux-arm64";
    x86_64-linux = "linux-x86_64";
  }.${stdenv.system};
in

stdenv.mkDerivation {
  pname = "frida-${name}";
  inherit version;

  src = fetchurl {
    url = "https://build.frida.re/deps/${version}/${name}-${system}.tar.bz2";
    inherit hash;
  };

  dontUnpack = true;

  buildInputs = lib.optionals isToolchian [
    python3
  ];

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    tar xf $src -C $out
    runHook postInstall
  '';
}
