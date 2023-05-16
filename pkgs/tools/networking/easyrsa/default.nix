{ lib, stdenv, fetchFromGitHub, openssl, makeWrapper, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "easyrsa";
<<<<<<< HEAD
  version = "3.1.6";
=======
  version = "3.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "easy-rsa";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-VbL2QXc4IaTe6u17nhByIk+SEsKLhl6sk85E5moGfjs=";
=======
    sha256 = "sha256-nZjEBAJnho2Qis5uzQs1sVZVFHHSgJVa5aJS+dAfFCg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ makeWrapper ];

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
      --set EASYRSA_OPENSSL ${openssl.bin}/bin/openssl

    # Helper utility
    cat > $out/bin/easyrsa-init <<EOF
    #!${runtimeShell} -e
    cp -r $out/share/easy-rsa/* .
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
