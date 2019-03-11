{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "trezor-cipher-key-value-${version}";
  version = "v0.1";

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  goPackagePath = "github.com/petrkr/trezorCipherKeyValue";

  src = fetchFromGitHub {
    owner  = "petrkr";
    repo   = "trezorCipherKeyValue";
    rev    = "${version}";
    sha256 = "1mpfifyidjp7l851694364r59q1f82yvqchw5qj08n4fay72bf72";
  };

  patchPhase = ''
    sed -i 's|/lib/cryptsetup/askpass|trezor-askpass|g' "main.go"
  '';

  # Compile helper Askpass from debian cryptsetup package
  postInstall = ''
    gcc -pedantic -std=c99 $src/tools/askpass.c -o $bin/bin/trezor-askpass
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Pipeline utlility to encrypt/decrypt values using TREZOR device";
    homepage = https://www.github.com/xaionaro-go/trezorCipherKeyValue;
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [ petrkr ];
    platforms = platforms.linux;
  };
}
