{ stdenv, fetchFromGitHub, scons, pkgconfig, openssl, protobuf, boost, zlib}:

stdenv.mkDerivation rec {
  name = "rippled-${version}";
  version = "0.27.3-sp2";

  src = fetchFromGitHub {
    owner = "ripple";
    repo = "rippled";
    rev = version;
    sha256 = "1q4i87cc7yks9slpgrfnlimngm45n3h035ssjvywmfwhhh7r9m3y";
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

  meta = with stdenv.lib; {
    description = "Ripple P2P payment network reference server";
    homepage = https://ripple.com;
    maintainers = [ maintainers.emery maintainers.offline ];
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
