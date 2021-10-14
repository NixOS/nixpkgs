{ clojure, fetchFromGitHub, lib, graalvm11-ce, stdenv }:

stdenv.mkDerivation rec {
  pname = "carve";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "borkdude";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1yijjxhkl4hln4f2q2z20bpwmqn5brsi8l0iw8968nmh9s9qy1vq";
  };

  nativeBuildInputs = [ clojure graalvm11-ce ];

  buildPhase = ''
    runHook preBuild

    # Cannot create directory /homeless-shelter/.... Error: FILE_ERROR_ACCESS_DENIED
    export HOME=$TMPDIR

    # https://github.com/borkdude/carve/blob/a3a5b941d4327127e36541bf7322b15b33260386/script/compile#L10-L25
    clojure -Sdeps "$(cat $src/deps.edn)" -J-Dclojure.compiler.direct-linking=true -X:native:uberjar
    args=("-cp" "carve.jar"
          "-H:Name=${pname}"
          "-H:+ReportExceptionStackTraces"
          "--initialize-at-build-time"
          "-H:EnableURLProtocols=jar"
          "--report-unsupported-elements-at-runtime"
          "--verbose"
          "--no-fallback"
          "--no-server"
          "-J-Xmx3g"
          "carve.main")
     native-image ''${args[@]}
     runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp carve $out/bin/carve
  '';

  meta = with lib; {
    description = "Searches through Clojure code for unused vars and removes them";
    homepage = "https://github.com/borkdude/carve";
    license = licenses.epl10;
    platforms = graalvm11-ce.meta.platforms;
    maintainers = with maintainers; [ john-shaffer ];
  };
}
