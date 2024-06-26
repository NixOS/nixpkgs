{ lib
, bash
, dbus
, fetchFromGitHub
, fetchpatch
, installShellFiles
, libgit2
, libssh2
, openssl
, pkg-config
, rustPlatform
, systemd
, xz
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "ciel";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "AOSC-Dev";
    repo = "ciel-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-b8oTVtDcxrV41OtfuthIxjbgZTANCfYHQLRJnnEc93c=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libmount-0.1.15" = "sha256-t7CGGqJC85od8lOng9+Cn0+WDef6aciLLgxnQn1MrBk=";
    };
  };

  nativeBuildInputs = [ pkg-config installShellFiles ];

  # ciel has plugins which is actually bash scripts.
  # Therefore, bash is required for plugins to work.
  buildInputs = [ bash systemd dbus openssl libssh2 libgit2 xz zlib ];

  patches = [
    # cli,completions: use canonicalize path to find libexec location
    # FIXME: remove this patch after https://github.com/AOSC-Dev/ciel-rs/pull/16 is merged
    (fetchpatch {
      name = "use-canonicalize-path-to-find-libexec.patch";
      url = "https://github.com/AOSC-Dev/ciel-rs/commit/17f41538ed1057e855540f5abef7faf6ea4abf5c.patch";
      sha256 = "sha256-ELK2KpOuoBS774apomUIo8q1eXYs/FX895G7eBdgOQg=";
    })
  ];

  postInstall = ''
    mv -v "$out/bin/ciel-rs" "$out/bin/ciel"

    # From install-assets.sh
    install -Dm555 -t "$out/libexec/ciel-plugin" plugins/*

    # Install completions
    installShellCompletion --cmd ciel \
      --bash completions/ciel.bash \
      --fish completions/ciel.fish \
      --zsh completions/_ciel
  '';

  meta = with lib; {
    description = "Tool for controlling AOSC OS packaging environments using multi-layer filesystems and containers";
    homepage = "https://github.com/AOSC-Dev/ciel-rs";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yisuidenghua ];
    mainProgram = "ciel";
  };
}
