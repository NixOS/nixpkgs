{ stdenvNoCC
, fetchurl
, unzip
, pname
, version
, meta
}:

let
  appName = "Postman.app";
  dist = {
    aarch64-darwin = {
      arch = "arm64";
      sha256 = "sha256-EtTf17LS18zC3JMbSoyZGGHuIcwGN3Q15XOhVqeh7C4=";
    };

    x86_64-darwin = {
      arch = "64";
      sha256 = "sha256-kTgbqGPgOn5dyjL/IMl3hg2+VUfB+jpPJsqXof8UL+c=";
    };
  }.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

in

stdenvNoCC.mkDerivation {
  inherit pname version meta;

  src = fetchurl {
    url = "https://dl.pstmn.io/download/version/${version}/osx_${dist.arch}";
    inherit (dist) sha256;
    name = "${pname}-${version}.zip";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = appName;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{Applications/${appName},bin}
    cp -R . $out/Applications/${appName}
    cat > $out/bin/${pname} << EOF
    #!${stdenvNoCC.shell}
    open -na $out/Applications/${appName} --args "$@"
    EOF
    chmod +x $out/bin/${pname}
    runHook postInstall
  '';
}
