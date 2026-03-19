{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  openjdk11_headless,
  openjdk17_headless,
  systemd,
  nixosTests,
}:

{
  version,
  hash,
  maintainers,
  license,
}:
stdenv.mkDerivation rec {
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
    "${if (lib.versionAtLeast version "5.0") then openjdk17_headless else openjdk11_headless}"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ systemd ]}"
  ];

  passthru.tests = { inherit (nixosTests) graylog; };

  installPhase = ''
    mkdir -p $out
    cp -r {graylog.jar,bin,plugin} $out
  ''
  + lib.optionalString (lib.versionOlder version "4.3") ''
    cp -r lib $out
  ''
  + ''
    wrapProgram $out/bin/graylogctl $makeWrapperArgs
  '';

  meta = {
    description = "Open source log management solution";
    homepage = "https://www.graylog.org/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    inherit license;
    inherit maintainers;
    mainProgram = "graylogctl";
    # TODO: remove this after 26.05
    problems = lib.optionalAttrs (lib.versions.majorMinor version <= "6.1") {
      removal.message = "This package has been marked for removal in 26.11, Please consider upgrading to 7.0 or later to continue using this package after 26.11";
    };
    platforms = lib.platforms.unix;
  };
}
