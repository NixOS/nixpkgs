{ stdenv, fetchFromGitHub, openssl, runtimeShell }:

let
  version = "3.0.0";
in stdenv.mkDerivation {
  pname = "easyrsa";
  inherit version;

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "easy-rsa";
    rev = "v${version}";
    sha256 = "0wbdv3wmqwm5680rpb971l56xiw49adpicqshk3vhfmpvqzl4dbs";
  };

  patches = [ ./fix-paths.patch ];

  installPhase = ''
    mkdir -p $out/share/easyrsa
    cp -r easyrsa3/{openssl*.cnf,x509-types,vars.example} $out/share/easyrsa
    install -D -m755 easyrsa3/easyrsa $out/bin/easyrsa
    substituteInPlace $out/bin/easyrsa \
      --subst-var out \
      --subst-var-by openssl ${openssl.bin}/bin/openssl

    # Helper utility
    cat > $out/bin/easyrsa-init <<EOF
    #!${runtimeShell} -e
    cp -r $out/share/easyrsa/* .
    EOF
    chmod +x $out/bin/easyrsa-init
  '';

  meta = with stdenv.lib; {
    description = "Simple shell based CA utility";
    homepage = "https://openvpn.net/";
    license = licenses.gpl2;
    maintainers = [ maintainers.offline ];
    platforms = platforms.unix;
  };
}
