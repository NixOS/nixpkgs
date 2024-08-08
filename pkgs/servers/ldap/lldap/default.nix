{ binaryen
, fetchFromGitHub
, fetchpatch
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

  commonDerivationAttrs = {
    pname = "lldap";
    version = "0.5.1-alpha-6aa930";

    src = fetchFromGitHub {
      owner = "lldap";
      repo = "lldap";
      # rev = "v${version}";
      # hash = "";
      rev = "6aa9303339ac1793b4be9ae01c56a6369a5d77f0";
      hash = "sha256-UbkpnPvDoTaioB0g1HBvRczqUEuPlVuH1gIVBU07RpY=";
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

    patches = [
      (fetchpatch {
        ## https://github.com/lldap/lldap/pull/947
        url = "https://github.com/lldap/lldap/compare/6aa9303339ac1793b4be9ae01c56a6369a5d77f0...620939be9c8c32f8ace4519cc49a7ac07d88fe87.patch";
        hash = "sha256-MlVP/2+qdRrCLsfJebq1F/uQTjYLT+b+0U8utx3XQb4=";
      })
    ];

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

  patches = commonDerivationAttrs.patches ++ [
    ./0001-parameterize-frontend-location.patch
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
    description = "Lightweight authentication server that provides an opinionated, simplified LDAP interface for authentication";
    homepage = "https://github.com/lldap/lldap";
    changelog = "https://github.com/lldap/lldap/blob/v${lldap.version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bendlas ];
    mainProgram = "lldap";
  };
})
