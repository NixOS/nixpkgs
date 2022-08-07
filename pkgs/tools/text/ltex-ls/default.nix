{ lib, stdenv, fetchurl, makeBinaryWrapper, jre_headless }:

stdenv.mkDerivation rec {
  pname = "ltex-ls";
  version = "15.2.0";

  src = fetchurl {
    url = "https://github.com/valentjn/ltex-ls/releases/download/${version}/ltex-ls-${version}.tar.gz";
    sha256 = "sha256-ygjCFjYaP9Lc5BLuOHe5+lyaKpfDhicR783skkBgo7I=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -rfv bin/ lib/ $out
    rm -fv $out/bin/*.bat
    for file in $out/bin/{ltex-ls,ltex-cli}; do
      wrapProgram $file --set JAVA_HOME "${jre_headless}"
    done

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://valentjn.github.io/ltex/";
    description = "LSP language server for LanguageTool";
    license = licenses.mpl20;
    maintainers = [ maintainers.marsam ];
    platforms = jre_headless.meta.platforms;
  };
}
