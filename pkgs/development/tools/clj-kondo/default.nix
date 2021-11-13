{ stdenv, lib, graalvm11-ce, fetchurl }:

stdenv.mkDerivation rec {
  pname = "clj-kondo";
  version = "2021.10.19";

  src = fetchurl {
    url = "https://github.com/clj-kondo/${pname}/releases/download/v${version}/${pname}-${version}-standalone.jar";
    sha256 = "sha256-i0OeQPZfQPUeXC/Bs84I91IahBKK6W1mFix97s8/lVA=";
  };

  dontUnpack = true;

  buildInputs = [ graalvm11-ce ];

  buildPhase = ''
    runHook preBuild

    # https://github.com/clj-kondo/clj-kondo/blob/v2021.10.19/script/compile#L17-L21
    args=("-jar" "$src"
          "-H:CLibraryPath=${graalvm11-ce.lib}/lib"
          # Required to build babashka on darwin. Do not remove.
          "${lib.optionalString stdenv.isDarwin "-H:-CheckToolchain"}"
          "-H:+ReportExceptionStackTraces"
          "--verbose"
          "--no-fallback"
          "-J-Xmx3g")

     native-image ''${args[@]}

     runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp clj-kondo $out/bin/clj-kondo
  '';

  meta = with lib; {
    description = "A linter for Clojure code that sparks joy";
    homepage = "https://github.com/clj-kondo/clj-kondo";
    license = licenses.epl10;
    platforms = graalvm11-ce.meta.platforms;
    maintainers = with maintainers; [ jlesquembre bandresen thiagokokada ];
  };
}
