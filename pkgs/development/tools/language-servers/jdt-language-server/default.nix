{ lib
, stdenv
, fetchurl
, makeWrapper
, jdk
}:

stdenv.mkDerivation rec {
  pname = "jdt-language-server";
  version = "1.21.0";
  timestamp = "202303161431";

  src = fetchurl {
    url = "https://download.eclipse.org/jdtls/milestones/${version}/jdt-language-server-${version}-${timestamp}.tar.gz";
    sha256 = "sha256-c8RDSvOgLbl05LDNelKgQXucbJnjJ7GVcut6mVT6GjA=";
  };

  sourceRoot = ".";

  buildInputs = [
    jdk
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase =
    let
      # The application ships with config directories for linux and mac
      configDir = if stdenv.isDarwin then "config_mac" else "config_linux";
    in
      ''
      # Copy jars
      install -D -t $out/share/java/plugins/ plugins/*.jar

      # Copy config directories for linux and mac
      install -Dm 444 -t $out/share/config ${configDir}/*

      # Get latest version of launcher jar
      # e.g. org.eclipse.equinox.launcher_1.5.800.v20200727-1323.jar
      launcher="$(ls $out/share/java/plugins/org.eclipse.equinox.launcher_* | sort -V | tail -n1)"

      # The wrapper script will create a directory in the user's cache, copy in the config
      # files since this dir can't be read-only, and by default use this as the runtime dir.
      #
      # The following options are required as per the upstream documentation:
      #
      #   -Declipse.application=org.eclipse.jdt.ls.core.id1
      #   -Dosgi.bundles.defaultStartLevel=4
      #   -Declipse.product=org.eclipse.jdt.ls.core.product
      #   --add-modules=ALL-SYSTEM
      #   --add-opens java.base/java.util=ALL-UNNAMED
      #   --add-opens java.base/java.lang=ALL-UNNAMED
      #
      # The following options configure the server to run without writing logs to the nix store:
      #
      #   -Dosgi.sharedConfiguration.area.readOnly=true
      #   -Dosgi.checkConfiguration=true
      #   -Dosgi.configuration.cascaded=true
      #   -Dosgi.sharedConfiguration.area=$out/share/config
      #
      # Other options which the caller may change:
      #
      #   -Dlog.level:
      #     Log level.
      #     This can be overidden by setting JAVA_OPTS.
      #
      # The caller must specify the following:
      #
      #   -data:
      #     The application stores runtime data here. We set this to <cache-dir>/$PWD
      #     so that projects don't collide with each other.
      #     This can be overidden by specifying -configuration to the wrapper.
      #
      # Java options, such as -Xms and Xmx can be specified by setting JAVA_OPTS.
      #
      makeWrapper ${jdk}/bin/java $out/bin/jdt-language-server \
        --add-flags "-Declipse.application=org.eclipse.jdt.ls.core.id1" \
        --add-flags "-Dosgi.bundles.defaultStartLevel=4" \
        --add-flags "-Declipse.product=org.eclipse.jdt.ls.core.product" \
        --add-flags "-Dosgi.sharedConfiguration.area=$out/share/config" \
        --add-flags "-Dosgi.sharedConfiguration.area.readOnly=true" \
        --add-flags "-Dosgi.checkConfiguration=true" \
        --add-flags "-Dosgi.configuration.cascaded=true" \
        --add-flags "-Dlog.level=ALL" \
        --add-flags "\$JAVA_OPTS" \
        --add-flags "-jar $launcher" \
        --add-flags "--add-modules=ALL-SYSTEM" \
        --add-flags "--add-opens java.base/java.util=ALL-UNNAMED" \
        --add-flags "--add-opens java.base/java.lang=ALL-UNNAMED"
    '';

  meta = with lib; {
    homepage = "https://github.com/eclipse/eclipse.jdt.ls";
    description = "Java language server";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.epl20;
    maintainers = with maintainers; [ matt-snider ];
  };
}
