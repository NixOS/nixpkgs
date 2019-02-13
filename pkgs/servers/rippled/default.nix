{ stdenv, fetchFromGitHub, scons, pkgconfig, openssl, protobuf, boost, zlib}:

stdenv.mkDerivation rec {
  name = "rippled-${version}";
  version = "0.30.0-rc1";

  src = fetchFromGitHub {
    owner = "ripple";
    repo = "rippled";
    rev = version;
    sha256 = "0l1dg29mg6wsdkh0lwi2znpl2wcm6bs6d3lswk5g1m1nk2mk7lr7";
  };

  postPatch = ''
    sed -i -e "s@ENV = dict.*@ENV = os.environ@g" SConstruct
  '';

  nativeBuildInputs = [ pkgconfig scons ];
  buildInputs = [ openssl protobuf boost zlib ];

  postInstall = ''
    mkdir -p $out/bin
    cp build/rippled $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "Ripple P2P payment network reference server";
    homepage = https://ripple.com;
    maintainers = with maintainers; [ ehmry offline ];
    license = licenses.isc;
    platforms = [ "x86_64-linux" ];
    broken = true;
  };
}
