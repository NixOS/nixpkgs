{ lib, stdenv, fetchFromGitHub, openssl_1_1, runtimeShell }:

let
  version = "3.0.8";
in stdenv.mkDerivation {
  pname = "easyrsa";
  inherit version;

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "easy-rsa";
    rev = "v${version}";
    sha256 = "05q60s343ydh9j6hzj0840qdcq8fkyz06q68yw4pqgqg4w68rbgs";
  };

  patches = [ ./fix-paths.patch ];

  installPhase = ''
    mkdir -p $out/share/easyrsa
    cp -r easyrsa3/{*.cnf,x509-types,vars.example} $out/share/easyrsa
    cp easyrsa3/openssl-easyrsa.cnf $out/share/easyrsa/safessl-easyrsa.cnf
    install -D -m755 easyrsa3/easyrsa $out/bin/easyrsa
    substituteInPlace $out/bin/easyrsa \
      --subst-var out \
      --subst-var-by openssl ${openssl_1_1.bin}/bin/openssl

    # Helper utility
    cat > $out/bin/easyrsa-init <<EOF
    #!${runtimeShell} -e
    cp -r $out/share/easyrsa/* .
    EOF
    chmod +x $out/bin/easyrsa-init
  '';

  meta = with lib; {
    description = "Simple shell based CA utility";
    homepage = "https://openvpn.net/";
    license = licenses.gpl2;
    maintainers = [ maintainers.offline maintainers.numinit ];
    platforms = platforms.unix;
  };
}
