{ stdenv, fetchFromGitHub
, cmake, pkgconfig, arpa2cm
, openldap, p11-kit, unbound, libtasn1, db, openssl, quickder, libkrb5, ldns, gnutls-kdh
, softhsm
}:

let
  pname = "tlspool";
  version = "20180227";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  src = fetchFromGitHub {
    owner = "arpa2";
    repo = "tlspool";
    rev = "b4459637d71c7602e94d455e23c74f3973b9cf30";
    sha256 = "0x78f2bdsiglwicwn3injm5ysfjlfa0yzdpnc0r3iw4z0n89rj2r";
  };

  nativeBuildInputs = [
    cmake pkgconfig arpa2cm
  ];

  buildInputs = [
    openldap p11-kit unbound libtasn1 db openssl quickder libkrb5 ldns gnutls-kdh
  ];

  postPatch = ''
    # CMake is probably confused because the current version isn't 1.2.6, but 1.2-6
    substituteInPlace CMakeLists.txt \
      --replace "Quick-DER 1.2.4" "Quick-DER 1.2"
    substituteInPlace etc/tlspool.conf \
      --replace "dnssec_rootkey ../etc/root.key" "dnssec_rootkey $out/etc/root.key" \
      --replace "pkcs11_path /usr/local/lib/softhsm/libsofthsm2.so" "pkcs11_path ${softhsm}/lib/softhsm/libsofthsm2.so"
  '';

  postInstall = ''
    mkdir -p $out/include/${pname}/pulleyback $out/etc/tlspool
    cp -R $src/etc/* $out/etc/tlspool/
    cp $src/include/tlspool/*.h $out/include/${pname}
    cp $src/pulleyback/*.h $out/include/${pname}/pulleyback/
    cp $src/src/*.h $out/include/${pname}
  '';

  meta = with stdenv.lib; {
    description = "A supercharged TLS daemon that allows for easy, strong and consistent deployment";
    license = licenses.gpl3;
    homepage = http://www.tlspool.org;
    maintainers = with maintainers; [ leenaars qknight ];
  };
}
