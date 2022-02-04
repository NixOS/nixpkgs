{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, makeWrapper
, gnugrep
, openssl
}:

stdenv.mkDerivation rec {
  pname = "easyrsa";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "easy-rsa";
    rev = "v${version}";
    sha256 = "sha256-zTdk8mv+gC/SHK813wZ6CWZf9Jm2XkKfAPU3feFpAkY=";
  };

  preBuild = ''
    mkdir -p $out/share/easy-rsa
  '';

  nativeBuildInputs = [ autoreconfHook makeWrapper ];
  buildInputs = [ gnugrep openssl ];

  # Make sane defaults and patch default config vars
  postInstall = ''
    cp $out/share/easy-rsa/openssl-1.0.0.cnf $out/share/easy-rsa/openssl.cnf
    for prog in $(find "$out/share/easy-rsa" -executable -type f); do
      makeWrapper "$prog" "$out/bin/$(basename $prog)" \
        --set EASY_RSA "$out/share/easy-rsa" \
        --set OPENSSL "${openssl.bin}/bin/openssl" \
        --set GREP "${gnugrep}/bin/grep"
    done
    sed -i "/EASY_RSA=\|OPENSSL=\|GREP=/d" $out/share/easy-rsa/vars
  '';

  meta = with lib; {
    description = "Simple shell based CA utility";
    homepage = "https://openvpn.net/";
    license = licenses.gpl2;
    maintainers = [ maintainers.offline ];
    platforms = platforms.linux;
  };
}
