{ lib, stdenv, fetchFromGitHub, jdk, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "async-profiler";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "async-profiler";
    repo = "async-profiler";
    rev = "v${version}";
    sha256 = "sha256-0CCJoRjRLq4LpiRD0ibzK8So9qSQymePCTYUI60Oy2k=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jdk ];

  postPatch = ''
    # Patching Java version since 7 is deprecated
    sed -i 's/-source 7 -target 7/-source 8 -target 8/g' Makefile
  '';

  installPhase = ''
    runHook preInstall
    install -D build/bin/asprof "$out/bin/asprof"
    install -D build/lib/libasyncProfiler.so "$out/lib/libasyncProfiler.so"
    install -D -t "$out/share/java/" build/lib/*.jar
    runHook postInstall
  '';

  fixupPhase = ''
    wrapProgram $out/bin/asprof --prefix PATH : ${lib.makeBinPath [ jdk ]}
  '';

  meta = with lib; {
    description = "A low overhead sampling profiler for Java that does not suffer from Safepoint bias problem";
    homepage    = "https://github.com/jvm-profiling-tools/async-profiler";
    license     = licenses.asl20;
    maintainers = with maintainers; [ mschuwalow ];
    platforms   = platforms.all;
  };
}
