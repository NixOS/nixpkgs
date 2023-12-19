{ lib, stdenv, runtimeShell, fetchFromGitHub, gradle_7, openjdk17 }:
let
  pname = "fastddsgen";
  version = "2.5.1";

  gradle = gradle_7;

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Fast-DDS-Gen";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-3x99FfdxSfqa2+BNZ3lZQzRgjwGhbm5PKezoS6fs5Ts=";
  };

  nativeBuildInputs = [ gradle openjdk17 ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [ "-x" "submodulesUpdate" ];

  installPhase = ''
    runHook preInstall

    gradle install --install_path=$out

    # Override the default start script to use absolute java path
    cat  <<EOF >$out/bin/fastddsgen
    #!${runtimeShell}
    exec ${openjdk17}/bin/java -jar "$out/share/fastddsgen/java/fastddsgen.jar" "\$@"
    EOF
    chmod a+x "$out/bin/fastddsgen"

    runHook postInstall
  '';

  passthru.updateDeps = gradle.updateDeps { inherit pname; };

  meta = with lib; {
    description = "Fast-DDS IDL code generator tool";
    homepage = "https://github.com/eProsima/Fast-DDS-Gen";
    license = licenses.asl20;
    longDescription = ''
      eProsima Fast DDS-Gen is a Java application that generates
      eProsima Fast DDS C++ or Python source code using the data types
      defined in an IDL (Interface Definition Language) file. This
      generated source code can be used in any Fast DDS application in
      order to define the data type of a topic, which will later be
      used to publish or subscribe.
    '';
    maintainers = with maintainers; [ wentasah ];
    platforms = openjdk17.meta.platforms;
  };
}
