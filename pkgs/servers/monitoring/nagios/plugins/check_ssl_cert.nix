{ pkgs, openssl }:
#with import <nixpkgs> {};
with pkgs;

stdenv.mkDerivation rec {
  name = "check_ssl_cert-${version}";
  version = "1.51.0";

  src = fetchgit {
    url = https://github.com/matteocorti/check_ssl_cert;
    rev = "4e31a82008a48cd6efb82914e0bb1e136b339a31"; # v1.51.0
    sha256 = "1x1lcxxgzvjznn1iyla4hmc02c0vqdbzvd8xj61niknm02q07lcf";
  };

  buildInputs = [ makeWrapper file ];
  #nativeBuildInputs = [ makeWrapper ];

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/man
    cp check_ssl_cert $out/bin
    cp check_ssl_cert.1 $out/man1
    wrapProgram $out/bin/check_ssl_cert \
      --prefix PATH : "${openssl}/bin:${file}/bin"
  '';

  meta = {
    description = "A Nagios plugin to check the CA and validity of an X.509 certificate";
    license = stdenv.lib.licenses.gpl3;
  };
}
