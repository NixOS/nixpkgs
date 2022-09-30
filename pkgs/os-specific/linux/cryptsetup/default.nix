{ lib, stdenv, fetchurl, lvm2, json_c, asciidoctor
, openssl, libuuid, pkg-config, popt }:

stdenv.mkDerivation rec {
  pname = "cryptsetup";
  version = "2.5.0";

  outputs = [ "bin" "out" "dev" "man" ];
  separateDebugInfo = true;

  src = fetchurl {
    url = "mirror://kernel/linux/utils/cryptsetup/v2.5/${pname}-${version}.tar.xz";
    sha256 = "sha256-kYSm672c5+shEVLn90GmyC8tHMDiSoTsnFKTnu4PBUI=";
  };

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

  nativeBuildInputs = [ pkg-config asciidoctor ];
  buildInputs = [ lvm2 json_c openssl libuuid popt ];

  # The test [7] header backup in compat-test fails with a mysterious
  # "out of memory" error, even though tons of memory is available.
  # Issue filed upstream: https://gitlab.com/cryptsetup/cryptsetup/-/issues/763
  doCheck = !stdenv.hostPlatform.isMusl;

  meta = {
    homepage = "https://gitlab.com/cryptsetup/cryptsetup/";
    description = "LUKS for dm-crypt";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
