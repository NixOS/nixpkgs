{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, cyclonedds
, libmysqlclient
, mariadb
, mbedtls
, sqlite
, zeromq
, flex
, bison

# for tests
, python3
, mosquitto
, netcat-gnu
}:

let

  # exposing as full package in its own right would be a
  # bit absurd - repo doesn't even have a license.
  idl-serial = stdenv.mkDerivation {
    pname = "idl-serial";
    version = "unstable-2023-03-29";

    src = fetchFromGitHub {
      owner = "nanomq";
      repo = "idl-serial";
      rev = "908c364dab4c0dcdd77b8de698d29c8a0b6d3830";
      hash = "sha256-3DS9DuzHN7BevfgiekUmKKH9ej9wKTrt6Fuh427NC4I=";
    };

    nativeBuildInputs = [ cmake ninja flex bison ];

    # https://github.com/nanomq/idl-serial/issues/36
    hardeningDisable = [ "fortify3" ];
  };

in stdenv.mkDerivation (finalAttrs: {
  pname = "nanomq";
  version = "0.20.8";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "nanomq";
    rev = finalAttrs.version;
    hash = "sha256-VCKlXQ7qvBab+wRDnJ6EUA5qaQ36gTFfuerN1GU6sW0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION /etc" "DESTINATION $out/etc"
  '';

  nativeBuildInputs = [ cmake ninja pkg-config idl-serial ];

  buildInputs = [ cyclonedds libmysqlclient mariadb mbedtls sqlite zeromq ];

  cmakeFlags = [
    "-DBUILD_BENCH=ON"
    "-DBUILD_DDS_PROXY=ON"
    "-DBUILD_NANOMQ_CLI=ON"
    "-DBUILD_ZMQ_GATEWAY=ON"
    "-DENABLE_RULE_ENGINE=ON"
    "-DNNG_ENABLE_SQLITE=ON"
    "-DNNG_ENABLE_TLS=ON"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-return-type -Wno-implicit-function-declaration -Wno-error=implicit-int";

  # disabled by default - not 100% reliable and making nanomq depend on
  # mosquitto would annoy people
  doInstallCheck = false;
  nativeInstallCheckInputs = [
    mosquitto
    netcat-gnu
    (python3.withPackages (ps: with ps; [ jinja2 requests paho-mqtt ]))
  ];
  installCheckPhase = ''
    runHook preInstallCheck

    (
      cd ..

      # effectively distable this test because it is slow
      echo > .github/scripts/fuzzy_test.txt

      PATH="$PATH:$out/bin" python .github/scripts/test.py
    )

    runHook postInstallCheck
  '';

  passthru.tests = {
    withInstallChecks = finalAttrs.finalPackage.overrideAttrs (_: { doInstallCheck = true; });
  };

  meta = with lib; {
    description = "Ultra-lightweight and blazing-fast MQTT broker for IoT edge";
    homepage = "https://nanomq.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
