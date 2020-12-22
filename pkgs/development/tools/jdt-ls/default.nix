{ lib
, stdenv
, fetchurl
, jdk
, bash
}:

stdenv.mkDerivation rec {
  pname = "jdt-ls";
  version = "0.67.0";
  timestamp = "202012170459";

  src = fetchurl {
    url = "https://download.eclipse.org/jdtls/milestones/${version}/jdt-language-server-${version}-${timestamp}.tar.gz";
    sha256 = "11qzwf2l737hdv1g7bfcrmdxcrl7g9z2k9nhy9lknlabmhq4mcdl";
  };

  # After running unpackPhase, the generic builder changes the current directory
  # to the directory created by unpacking the sources. If there are multiple
  # source directories, you should set sourceRoot to the name of the intended
  # directory.
  sourceRoot = ".";

  buildInputs = [
    bash
    jdk
  ];

  installPhase =
    let
      # There are config_ss_* directories too, use them to run the lightweight
      # version, see
      # https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-lightweight-syntax-language-server
      config-path = if stdenv.isDarwin then "config_mac" else "config_linux";
    in
    ''
      JARs_dir=$out/share/plugins

      # Copy files
      install -Dm 444 -t $JARs_dir plugins/*.jar
      install -Dm 444 -t $out/share/config ${config-path}/*
      install -Dm 755 ${./jdt-ls-wrapper.sh} $out/bin/jdt-ls

      launcher="$(ls $JARs_dir/org.eclipse.equinox.launcher_* | sort -V | tail -n1)"
      substituteInPlace $out/bin/jdt-ls \
        --subst-var-by shell ${bash}/bin/bash \
        --subst-var-by jdk ${jdk}/bin/java \
        --subst-var-by config_path $out/share/config \
        --subst-var launcher
    '';

  meta = with lib; {
    homepage = "https://github.com/eclipse/eclipse.jdt.ls";
    description = "Java language server";
    license = licenses.epl20;
    maintainers = with maintainers; [ matt-snider jlesquembre ];
  };
}
