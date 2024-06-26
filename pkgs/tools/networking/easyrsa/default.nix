{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  makeWrapper,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "easyrsa";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "easy-rsa";
    rev = "v${version}";
    hash = "sha256-hjebDE7Ts93vtoOTquFbfTWdInhI7HXc4pRxIsvNLtg=";
  };

  nativeBuildInputs = [ makeWrapper ];
  nativeInstallCheckInputs = [ openssl.bin ];

  installPhase = ''
    mkdir -p $out/share/easy-rsa
    cp -r easyrsa3/{*.cnf,x509-types,vars.example} $out/share/easy-rsa
    install -D -m755 easyrsa3/easyrsa $out/bin/easyrsa

    substituteInPlace $out/bin/easyrsa \
      --replace /usr/ $out/ \
      --replace '~VER~' '${version}' \
      --replace '~GITHEAD~' 'v${version}' \
      --replace '~DATE~' '1970-01-01'

    # Wrap it with the correct OpenSSL binary.
    wrapProgram $out/bin/easyrsa \
      --set-default EASYRSA_OPENSSL ${openssl.bin}/bin/openssl

    # Helper utility
    cat > $out/bin/easyrsa-init <<EOF
    #!${runtimeShell} -e
    cp -r $out/share/easy-rsa/* .
    EOF
    chmod +x $out/bin/easyrsa-init
  '';

  doInstallCheck = true;
  postInstallCheck = ''
    set -euo pipefail
    export EASYRSA_BATCH=1
    export EASYRSA_PASSIN=pass:nixpkgs
    export EASYRSA_PASSOUT="$EASYRSA_PASSIN"
    export EASYRSA_REQ_CN='nixpkgs test CA'
    export EASYRSA_KEY_SIZE=3072
    export EASYRSA_ALGO=rsa
    export EASYRSA_DIGEST=sha512
    $out/bin/easyrsa init-pki
    $out/bin/easyrsa build-ca
    openssl x509 -in pki/ca.crt -noout -subject | tee /dev/stderr | grep -zq "$EASYRSA_REQ_CN"
  '';

  meta = with lib; {
    description = "Simple shell based CA utility";
    homepage = "https://openvpn.net/";
    license = licenses.gpl2Only;
    maintainers = [
      maintainers.offline
      maintainers.numinit
    ];
    platforms = platforms.unix;
  };
}
