{ stdenv, fetchFromGitHub, scons, pkgconfig, openssl, protobuf, boost, zlib}:

stdenv.mkDerivation rec {
  name = "rippled-${version}";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "ripple";
    repo = "rippled";
    rev = "0.26.2";
    sha256 = "06hcc3nnzp9f6j00890f41rrn4djwlcwkzmqnw4yra74sswgji5y";
  };

  postPatch = ''
    sed -i -e "s@ENV = dict.*@ENV = os.environ@g" SConstruct
  '';

  buildInputs = [ scons pkgconfig openssl protobuf boost zlib ];

  buildPhase = "scons build/rippled";

  installPhase = ''
    mkdir -p $out/bin    
    cp build/rippled $out/bin/
  '';

  meta = {
    description = "Ripple P2P payment network reference server";
    homepage = https://ripple.com;
    maintainers = [ stdenv.lib.maintainers.emery ];
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
  };
}
