{
  lib,
  stdenv,
  fetchurl,
  lvm2,
  json_c,
  asciidoctor,
  openssl,
  libuuid,
  pkg-config,
  popt,
  nixosTests,
  libargon2,
  withInternalArgon2 ? false,

  # Programs enabled by default upstream are implicitly enabled unless
  # manually set to false.
  programs ? { },
  # The release tarballs contain precomputed manpage files, so we don't need
  # to run asciidoctor on the man sources. By avoiding asciidoctor, we make
  # the bare NixOS build hash independent of changes to the ruby ecosystem,
  # saving mass-rebuilds.
  rebuildMan ? false,
}:

stdenv.mkDerivation rec {
  pname = "cryptsetup";
  version = "2.7.3";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
  ];
  separateDebugInfo = true;

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    hash = "sha256-t3KuT23wzucgCyjOqWDk2q/yogPS/VAr6rPBMXsHpFY=";
  };

  patches = [
    # Allow reading tokens from a relative path, see #167994
    ./relative-token-path.patch
  ];

  postPatch = ''
    patchShebangs tests

    # O_DIRECT is filesystem dependent and fails in a sandbox (on tmpfs)
    # and on several filesystem types (btrfs, zfs) without sandboxing.
    # Remove it, see discussion in #46151
    substituteInPlace tests/unit-utils-io.c --replace "| O_DIRECT" ""
  '';

  NIX_LDFLAGS = lib.optionalString (stdenv.cc.isGNU && !stdenv.hostPlatform.isStatic) "-lgcc_s";

  configureFlags =
    [
      "--with-crypto_backend=openssl"
      "--disable-ssh-token"
    ]
    ++ lib.optionals (!rebuildMan) [
      "--disable-asciidoc"
    ]
    ++ lib.optionals (!withInternalArgon2) [
      "--enable-libargon2"
    ]
    ++ lib.optionals stdenv.hostPlatform.isStatic [
      "--disable-external-tokens"
      # We have to override this even though we're removing token
      # support, because the path still gets included in the binary even
      # though it isn't used.
      "--with-luks2-external-tokens-path=/"
    ]
    ++ (with lib; mapAttrsToList (flip enableFeature)) programs;

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals rebuildMan [ asciidoctor ];
  buildInputs = [
    lvm2
    json_c
    openssl
    libuuid
    popt
  ] ++ lib.optional (!withInternalArgon2) libargon2;

  # The test [7] header backup in compat-test fails with a mysterious
  # "out of memory" error, even though tons of memory is available.
  # Issue filed upstream: https://gitlab.com/cryptsetup/cryptsetup/-/issues/763
  doCheck = !stdenv.hostPlatform.isMusl;

  passthru = {
    tests = {
      nixos = lib.optionalAttrs stdenv.hostPlatform.isLinux (
        lib.recurseIntoAttrs (
          lib.filterAttrs (name: _value: lib.hasPrefix "luks" name) nixosTests.installer
        )
      );
    };
  };

  meta = {
    homepage = "https://gitlab.com/cryptsetup/cryptsetup/";
    description = "LUKS for dm-crypt";
    changelog = "https://gitlab.com/cryptsetup/cryptsetup/-/raw/v${version}/docs/v${version}-ReleaseNotes";
    license = lib.licenses.gpl2;
    mainProgram = "cryptsetup";
    maintainers = with lib.maintainers; [ raitobezarius ];
    platforms = with lib.platforms; linux;
  };
}
