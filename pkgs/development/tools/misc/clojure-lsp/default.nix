{ lib, stdenv, fetchurl, graalvm11-ce }:

stdenv.mkDerivation rec {
  pname = "clojure-lsp";
  version = "2021.02.14-19.46.47";

  src = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/${pname}.jar";
    sha256 = "sha256-fLwubRwWa1fu37bdkaCr2uZK79z37wqPLToOb5BlegY=";
  };

  dontUnpack = true;

  buildInputs = [ graalvm11-ce ];

  buildPhase = with lib; ''
    args=("-jar" "${src}"
          "-H:Name=clojure-lsp"
          ${optionalString stdenv.isDarwin ''"-H:-CheckToolchain"''}
          "-J-Dclojure.compiler.direct-linking=true"
          "-J-Dclojure.spec.skip-macros=true"
          "-H:+ReportExceptionStackTraces"
          "--enable-url-protocols=jar"
          # "-H:+InlineBeforeAnalysis"
          "-H:Log=registerResource:"
          "--verbose"
          "-H:IncludeResources=\"CLOJURE_LSP_VERSION|db/.*|static/.*|templates/.*|.*.yml|.*.xml|.*/org/sqlite/.*|org/sqlite/.*|.*.properties\""
          "-H:ConfigurationFileDirectories=graalvm"
          "--initialize-at-build-time"
          "--report-unsupported-elements-at-runtime"
          "--no-server"
          "--no-fallback"
          "--native-image-info"
          "--allow-incomplete-classpath"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.AudioFileReader"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiFileReader"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.MixerProvider"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.FormatConversionProvider"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.sampled.spi.AudioFileWriter"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiDeviceProvider"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.SoundbankReader"
          "-H:ServiceLoaderFeatureExcludeServices=javax.sound.midi.spi.MidiFileWriter"
          "-J-Xmx4g")

    native-image "''${args[@]}"
  '';

  installPhase = ''
    install -Dm755 clojure-lsp $out/bin/clojure-lsp
  '';

  installCheckPhase = ''
    $out/bin/clojure-lsp --version
  '';

  meta = with lib; {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/snoe/clojure-lsp";
    license = licenses.mit;
    maintainers = [ maintainers.ericdallo ];
    platforms = graalvm11-ce.meta.platforms;
  };
}
