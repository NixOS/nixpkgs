{ pkgs, stdenv, fetchFromGitHub, unzip, libtool, pkgconfig, git, p11_kit,
  libtasn1, db, openldap, libmemcached, cyrus_sasl, openssl, softhsm, bash,
  python, libkrb5, quickder, unbound, ldns, gnupg, gnutls-kdh,
  useSystemd ? true, systemd, swig
}:

let
  pname = "tlspool";
  version = "20170123";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  src = fetchFromGitHub { 
    owner = "arpa2";
    repo = "tlspool";
    rev = "90cfa0758b02849114ba6373f280a4f2d3e534bf";
    sha256 = "1qyq6da5bsgb8y9f3jhfrnhbvjns4k80lpkrydkvfx83bg494370";
  };

  propagatedBuildInputs = [ python softhsm openldap p11_kit.dev p11_kit.out gnupg ];
  buildInputs = [ unbound pkgconfig unzip git libtasn1 db libmemcached cyrus_sasl openssl bash quickder
                  libkrb5 ldns libtool swig pkgs.pythonPackages.pip gnutls-kdh ]
                ++ stdenv.lib.optional useSystemd systemd;

  phases = [ "unpackPhase" "patchPhase" "postPatchPhase" "buildPhase" "installPhase" ]; 

  patches = [ ./fixing-rpath.patch ./configvar-fix.patch ];

  postPatchPhase = ''
    substituteInPlace etc/tlspool.conf \
      --replace "dnssec_rootkey ../etc/root.key" "dnssec_rootkey $out/etc/root.key" \
      --replace "pkcs11_path /usr/local/lib/softhsm/libsofthsm2.so" "pkcs11_path ${softhsm}/lib/softhsm/libsofthsm2.so"
    substituteInPlace lib/Makefile \
      --replace "DESTDIR=\$(DESTDIR) PREFIX=\$(PREFIX)" "DESTDIR=\$(DESTDIR) PREFIX=\$(PREFIX) SWIG=${swig}/bin/swig"
  '';

  buildPhase = ''
    make clean
    make DESTDIR=$out PREFIX=/ all
  '';

  installPhase = ''
    mkdir -p $out/bin $out/lib $out/sbin $out/man $out/etc/tlspool/ $out/include/${pname}/pulleyback
    mkdir -p $out/${python.sitePackages}/tlspool
    mkdir -p $out/bdb
    make DESTDIR=$out PREFIX=/ install
    cp -R etc/* $out/etc/tlspool/
    cp include/tlspool/*.h $out/include/${pname}
    cp pulleyback/*.h $out/include/${pname}/pulleyback/
    cp src/*.h $out/include/${pname}
  '';

  meta = with stdenv.lib; {
    description = "A supercharged TLS daemon that allows for easy, strong and consistent deployment";
    license = licenses.bsd2;
    homepage = https://www.tlspool.org;
    maintainers = with maintainers; [ leenaars qknight ];
  };
}
