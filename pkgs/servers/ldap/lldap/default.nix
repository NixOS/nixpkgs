{ binaryen
, fetchFromGitHub
, lib
, lldap
, nixosTests
, rustPlatform
, rustc
, wasm-bindgen-cli
, wasm-pack
, which
}:

let

  wasm-bindgen-84 = wasm-bindgen-cli.override {
    version = "0.2.84";
    hash = "sha256-0rK+Yx4/Jy44Fw5VwJ3tG243ZsyOIBBehYU54XP/JGk=";
    cargoHash = "sha256-vcpxcRlW1OKoD64owFF6mkxSqmNrvY+y3Ckn5UwEQ50=";
  };

  commonDerivationAttrs = rec {
    pname = "lldap";
    version = "0.5.0";

    src = fetchFromGitHub {
      owner = "lldap";
      repo = "lldap";
      rev = "v${version}";
      hash = "sha256-2MEfwppkS9l3iHPNlkJB4tJnma0xMi0AckLv6wpzy1Y=";
    };

    # `Cargo.lock` has git dependencies, meaning can't use `cargoHash`
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "lber-0.4.1" = "sha256-2rGTpg8puIAXggX9rEbXPdirfetNOHWfFc80xqzPMT4=";
        "opaque-ke-0.6.1" = "sha256-99gaDv7eIcYChmvOKQ4yXuaGVzo2Q6BcgSQOzsLF+fM=";
        "yew_form-0.1.8" = "sha256-1n9C7NiFfTjbmc9B5bDEnz7ZpYJo9ZT8/dioRXJ65hc=";
      };
    };
  };

  frontend = rustPlatform.buildRustPackage (commonDerivationAttrs // {
    pname = commonDerivationAttrs.pname + "-frontend";

    nativeBuildInputs = [
      wasm-pack wasm-bindgen-84 binaryen which rustc rustc.llvmPackages.lld
    ];

    buildPhase = ''
      HOME=`pwd` ./app/build.sh
    '';

    installPhase = ''
      mkdir -p $out
      cp -R app/{index.html,pkg,static} $out/
    '';

    doCheck = false;
  });

in rustPlatform.buildRustPackage (commonDerivationAttrs // {

  cargoBuildFlags = [ "-p" "lldap" "-p" "lldap_migration_tool" "-p" "lldap_set_password" ];

  patches = [
    ./static-frontend-path.patch
  ];

  postPatch = ''
    substituteInPlace server/src/infra/tcp_server.rs --subst-var-by frontend '${frontend}'
  '';

  passthru = {
    inherit frontend;
    tests = {
      inherit (nixosTests) lldap;
    };
  };

  meta = with lib; {
    description = "A lightweight authentication server that provides an opinionated, simplified LDAP interface for authentication";
    homepage = "https://github.com/lldap/lldap";
    changelog = "https://github.com/lldap/lldap/blob/v${lldap.version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bendlas ];
    mainProgram = "lldap";
  };
})
