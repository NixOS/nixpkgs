{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
}:

maven.buildMavenPackage rec {
  pname = "jd-cli";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "intoolswetrust";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-rRttA5H0A0c44loBzbKH7Waoted3IsOgxGCD2VM0U/Q=";
  };

  mvnHash = "sha256-yqMAEjaNHxm/c/cbApiMjkN7V6Gx/crs1LPbD0k0cgk=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/share/jd-cli
    install -Dm644 jd-cli/target/jd-cli.jar $out/share/jd-cli

    makeWrapper ${jre}/bin/java $out/bin/jd-cli \
      --add-flags "-jar $out/share/jd-cli/jd-cli.jar"
  '';

  meta = with lib; {
    description = "Simple command line wrapper around JD Core Java Decompiler project";
    homepage = "https://github.com/intoolswetrust/jd-cli";
    license = licenses.gpl3;
    maintainers = with maintainers; [ majiir ];
  };
}
