{ lib
, stdenv
, fetchzip
, zlib
, autoPatchelfHook
,
}:
stdenv.mkDerivation rec {
  name = "kcctl";
  version = "1.0.0.alpha5";

  baseURL = "https://github.com/kcctl/kcctl/releases/download/v${builtins.replaceStrings ["a"] ["A"] version}/${name}-${version}";

  meta = with lib; {
    description = "A modern and intuitive command line client for Kafka Connect";
    homepage = "https://github.com/kcctl/kcctl";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

  src =
    if stdenv.isLinux
    then
      fetchzip
        {
          url = "${baseURL}-linux-x86_64.zip";
          sha256 = "sha256-FJOZrTzAXBh6K1HL4EF/4+doJWdua10+XH4nwSvS9No=";
        }
    else if stdenv.isDarwin
    then
      fetchzip
        {
          url = "${baseURL}-osx-x86_64.zip";
          sha256 = "sha256-dhUcKys4Np2LlL9RtJtHT3osXupkbodP/4s9EW9MKM8=";
        }
    else throw "Unsupported system: ${stdenv.system}";

  buildInputs = [
    zlib
  ];

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -m755 -D source/bin/kcctl $out/bin/kcctl

    runHook postInstall
  '';
}
