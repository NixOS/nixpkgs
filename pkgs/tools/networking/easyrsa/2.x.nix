{ stdenv, fetchurl, autoreconfHook, makeWrapper
, gnugrep, openssl }:

stdenv.mkDerivation rec {
  name = "easyrsa-2.2.0";

  src = fetchurl {
    url = "https://github.com/OpenVPN/easy-rsa/archive/v2.2.0.tar.gz";
    sha256 = "1xq4by5frb6ikn53ss3y8v7ss639dccxfq8jfrbk07ynkmk668qk";
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

  meta = with stdenv.lib; {
    description = "Simple shell based CA utility";
    homepage = http://openvpn.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.offline ];
    platforms = platforms.linux;
  };
}
