{
  lib,
  stdenv,
  fetchFromGitHub,
  aeron,
  cmake,
  makeWrapper,
  gradle,
  glib,
  jdk11,
  libbsd,
  perl,
  util-linux,
  writeText,
  zlib
}:

let
  pname = "aeronmd";
  version = aeron.version;
  src = aeron.src;

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [
      gradle
      jdk11
      perl
    ];

    buildPhase = ''
      export GRADLE_USER_HOME=$(mktemp -d)
      gradle \
        :aeron-archive:generateCppCodecs \
        --no-daemon \
        --console=plain \
        --quiet \
        --no-configuration-cache \
        --no-build-cache \
        --max-workers $NIX_BUILD_CORES \
        --system-prop org.gradle.java.home="${jdk11.home}" \
        --system-prop codec.target.dir=codecs \
        --exclude-task test \
        --exclude-task javadoc
    '';

    installPhase = ''
      mkdir --parents "$out/aeron_archive_client"
      cp --recursive aeron-archive/codecs/aeron_archive_client "$out/aeron_archive_client"
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-YYkgzb9oqvKoxxzfSV90sZnSYK/HjV2S3KiMA4Y5JTI=";
 };

in stdenv.mkDerivation rec {

  inherit pname src version;

  nativeBuildInputs = [
    aeron
    cmake
    jdk11
    util-linux
  ];

  buildInputs = [
    libbsd
    zlib
  ];

  patches = [
    ./0001-jar.patch
    ./0002-codecs.patch
  ];

  cmakeFlags = [
    "-DAERON_TESTS=OFF"
    "-DAERON_SYSTEM_TESTS=OFF"
  ];

  preBuild = ''
    mkdir --parents "./aeron-all/build/libs"
    ln -s "${aeron}/share/java/aeron-all-${version}.jar" "./aeron-all/build/libs/aeron-all-${version}.jar"
    ln -s "${deps}/aeron_archive_client" "generated"
  '';

  meta = with lib; {
    description = "Low-latency messaging media driver";
    homepage = "https://aeron.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.vaci ];
  };
}

