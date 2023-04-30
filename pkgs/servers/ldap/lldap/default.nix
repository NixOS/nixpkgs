{ fetchFromGitHub
, fetchzip
, lib
, lldap
, nixosTests
, rustPlatform
}:

let
  # We cannot build the wasm frontend from source, as the
  # wasm32-unknown-unknown rustc target isn't available in nixpkgs yet.
  # Tracking issue: https://github.com/NixOS/nixpkgs/issues/89426
  frontend = fetchzip {
    url = "https://github.com/lldap/lldap/releases/download/v${lldap.version}/amd64-lldap.tar.gz";
    hash = "sha256-/Ml4L5Gxpnmt1pLSiLNuxtzQYjTCatsVe/hE+Btl8BI=";
    name = "lldap-frontend-${lldap.version}";
    postFetch = ''
      mv $out $TMPDIR/extracted
      mv $TMPDIR/extracted/app $out
    '';
  };
in
rustPlatform.buildRustPackage rec {
  pname = "lldap";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "lldap";
    repo = "lldap";
    rev = "v${version}";
    hash = "sha256-FAUTykFh2eGVpx6LrCjV9xWbBPH8pCgAJv3vOXFMFZ4=";
  };

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

  patches = [
    ./static-frontend-path.patch
  ];

  postPatch = ''
    ln -s --force ${./Cargo.lock} Cargo.lock
    substituteInPlace server/src/infra/tcp_server.rs --subst-var-by frontend '${frontend}'
  '';

  passthru.tests = {
    inherit (nixosTests) lldap;
  };

  meta = with lib; {
    description = "A lightweight authentication server that provides an opinionated, simplified LDAP interface for authentication";
    homepage = "https://github.com/lldap/lldap";
    changelog = "https://github.com/lldap/lldap/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ indeednotjames ];
  };
}
