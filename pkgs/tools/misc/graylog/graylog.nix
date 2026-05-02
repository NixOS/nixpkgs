{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  openjdk17_headless,
  openjdk21_headless,
  nixosTests,
  udev,
  systemd,
}:
{
  version,
  hash,
  maintainers,
  license,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "graylog_${lib.versions.majorMinor version}";
  inherit version;

  src = fetchurl {
    url = "https://packages.graylog2.org/releases/graylog/graylog-${version}.tgz";
    inherit hash;
  };

  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];

  makeWrapperArgs = [
    "--set-default"
    "JAVA_HOME"
    "${if (lib.versionAtLeast version "7.0") then openjdk21_headless else openjdk17_headless}"
    "--set-default"
    "JAVA_CMD"
    "$JAVA_HOME/bin/java"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ systemd ]}"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ udev ]}"
  ];

  passthru.tests = { inherit (nixosTests) graylog; };

  installPhase = ''
    mkdir -p $out
    cp -r {graylog.jar,bin,plugin} $out
    wrapProgram $out/bin/graylogctl $makeWrapperArgs
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Self-Managed Log Management";
    homepage = "https://www.graylog.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    inherit license;
    inherit maintainers;
    mainProgram = "graylogctl";
    platforms = lib.platforms.unix;
  };
})
