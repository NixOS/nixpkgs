{ binaryen
, fetchFromGitHub
, fetchpatch
, fetchzip
, lib
, lldap
, nixosTests
, rustPlatform
, rustc
, stdenv
, wasm-bindgen-cli
, wasm-pack
, which
}:

let

  # replace with upstream wasm rustc, after resolution of
  # https://github.com/NixOS/nixpkgs/issues/89426
  rustc-wasm = (rustc.override {
    stdenv = stdenv.override {
      targetPlatform = stdenv.targetPlatform // {
        parsed = {
          cpu.name = "wasm32";
          vendor.name = "unknown";
          kernel.name = "unknown";
          abi.name = "unknown";
        };
      };
    };
  }).overrideAttrs (attrs: {
    configureFlags = attrs.configureFlags ++ ["--set=build.docs=false"];
  });

  commonDerivationAttrs = rec {
    pname = "lldap";
    version = "0.4.3";

    src = fetchFromGitHub {
      owner = "lldap";
      repo = "lldap";
      rev = "v${version}";
      hash = "sha256-FAUTykFh2eGVpx6LrCjV9xWbBPH8pCgAJv3vOXFMFZ4=";
    };

    postPatch = ''
      ln -s --force ${./Cargo.lock} Cargo.lock
    '';

    # `Cargo.lock` has git dependencies, meaning can't use `cargoHash`
    cargoLock = {
      # 0.4.3 has been tagged before the actual Cargo.lock bump, resulting in an inconsitent lock file.
      # To work around this, the Cargo.lock below is from the commit right after the tag:
      # https://github.com/lldap/lldap/commit/7b4188a376baabda48d88fdca3a10756da48adda
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
      wasm-pack wasm-bindgen-cli binaryen which rustc-wasm rustc-wasm.llvmPackages.lld
    ];

    buildPhase = ''
      HOME=`pwd` RUSTFLAGS="-C linker=lld" ./app/build.sh
    '';

    installPhase = ''
      mkdir -p $out
      cp -R app/{index.html,pkg,static} $out/
    '';

    doCheck = false;
  });

in rustPlatform.buildRustPackage (commonDerivationAttrs // {

  cargoBuildFlags = [ "-p" "lldap" "-p" "migration-tool" "-p" "lldap_set_password" ];

  patches = [
    ./static-frontend-path.patch
  ];

  postPatch = commonDerivationAttrs.postPatch + ''
    substituteInPlace server/src/infra/tcp_server.rs --subst-var-by frontend '${frontend}'
  '';

  postInstall = ''
    mv $out/bin/migration-tool $out/bin/lldap_migration_tool
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
    maintainers = with maintainers; [ emilylange bendlas ];
    mainProgram = "lldap";
  };
})
