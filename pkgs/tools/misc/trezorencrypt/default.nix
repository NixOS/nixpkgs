{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "trezorencrypt-${version}";
  version = "0.1.2";

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  goPackagePath = "github.com/petrkr/trezorencrypt";

  src = fetchFromGitHub {
    owner  = "petrkr";
    repo   = "trezorencrypt";
    rev    = "v${version}";
    sha256 = "0hp0p933af7z67biya9sb7136pm808pmp7ycnzlpyc0l7bi10jnq";
  };

  # Compile helper Askpass from debian cryptsetup package
  postInstall = ''
  gcc -pedantic -std=c99 $src/tools/askpass.c -o $bin/bin/trezor-askpass
  '';

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Pipeline utlility to encrypt/decrypt values using TREZOR device";
    homepage = https://www.github.com/petrkr/trezorencrypt;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ petrkr ];
    platforms = platforms.linux;
  };
}
