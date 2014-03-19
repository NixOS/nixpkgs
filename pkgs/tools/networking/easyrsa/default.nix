{ stdenv, fetchurl, autoconf, automake111x, makeWrapper
, gnugrep, openssl}:

stdenv.mkDerivation rec {
  name = "easyrsa-2.2.0";

  src = fetchurl {
    url = "https://github.com/OpenVPN/easy-rsa/archive/v2.2.0.tar.gz";
    sha256 = "1xq4by5frb6ikn53ss3y8v7ss639dccxfq8jfrbk07ynkmk668qk";
  };

  # Copy missing files and autoreconf
  preConfigure = ''
    cp ${automake111x}/share/automake/install-sh .
    cp ${automake111x}/share/automake/missing .

    autoreconf
  '';

  preBuild = ''
    mkdir -p $out/share/easy-rsa
  '';

  nativeBuildInputs = [ autoconf makeWrapper automake111x ];
  buildInputs = [ gnugrep openssl];

  # Make sane defaults and patch default config vars
  postInstall = ''
    for prog in $(find "$out/share/easy-rsa" -executable -type f); do
      makeWrapper "$prog" "$out/bin/$(basename $prog)" \
        --set EASY_RSA "$out/share/easy-rsa" \
        --set OPENSSL "${openssl}/bin/openssl" \
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
