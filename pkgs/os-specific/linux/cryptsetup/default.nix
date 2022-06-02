{ lib, stdenv, fetchurl, lvm2, json_c
, openssl, libuuid, pkg-config, popt }:

stdenv.mkDerivation rec {
  pname = "cryptsetup";
  version = "2.4.3";

  outputs = [ "bin" "out" "dev" "man" ];
  separateDebugInfo = true;

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v2.4/${pname}-${version}.tar.xz";
    sha256 = "sha256-/A35RRiBciZOxb8dC9oIJk+tyKP4VtR+upHzH+NUtQc=";
  };

  # Disable 4 test cases that fail in a sandbox
  patches = [ ./disable-failing-tests.patch ];

  postPatch = ''
    patchShebangs tests

    # O_DIRECT is filesystem dependent and fails in a sandbox (on tmpfs)
    # and on several filesystem types (btrfs, zfs) without sandboxing.
    # Remove it, see discussion in #46151
    substituteInPlace tests/unit-utils-io.c --replace "| O_DIRECT" ""
  '';

  NIX_LDFLAGS = lib.optionalString (stdenv.cc.isGNU && !stdenv.hostPlatform.isStatic) "-lgcc_s";

  configureFlags = [
    "--enable-cryptsetup-reencrypt"
    "--with-crypto_backend=openssl"
    "--disable-ssh-token"
  ] ++ lib.optionals stdenv.hostPlatform.isStatic [
    "--disable-external-tokens"
    # We have to override this even though we're removing token
    # support, because the path still gets included in the binary even
    # though it isn't used.
    "--with-luks2-external-tokens-path=/"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lvm2 json_c openssl libuuid popt ];

  doCheck = true;

  meta = {
    homepage = "https://gitlab.com/cryptsetup/cryptsetup/";
    description = "LUKS for dm-crypt";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
