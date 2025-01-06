{
  lib,
  stdenv,
  apacheHttpd,
  autoreconfHook,
  fetchFromGitHub,
  jdk,
}:

stdenv.mkDerivation rec {
  pname = "mod_jk";
  version = "1.2.50";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "tomcat-connectors";
    tag = "JK_${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-hlwlx7Sb4oeZIzHQYOC3e9xEZK9u6ZG8Q2U/XdKMe3U=";
  };

  sourceRoot = "${src.name}/native";

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [
    apacheHttpd
    jdk
  ];

  configureFlags = [
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--with-java-home=${jdk}"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/modules
    cp apache-2.0/mod_jk.so $out/modules

    runHook postInstall
  '';

  meta = {
    description = "Provides web server plugins to connect web servers with Tomcat";
    homepage = "https://tomcat.apache.org/download-connectors.cgi";
    changelog = "https://tomcat.apache.org/connectors-doc/miscellaneous/changelog.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    platforms = lib.platforms.unix;
  };
}
