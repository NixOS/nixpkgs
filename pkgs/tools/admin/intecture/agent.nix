{ stdenv, lib, fetchFromGitHub, rustPlatform
, openssl, zeromq, czmq, pkgconfig, cmake, zlib }:

with rustPlatform;

buildRustPackage rec {
  name = "intecture-agent-${version}";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "intecture";
    repo = "agent";
    rev = version;
    sha256 = "0j27qdgyxybaixggh7k57mpm6rifimn4z2vydk463msc8b3kgywj";
  };

  depsSha256 = "1n57i9wkak76ram748mwq0dn32d041ajd31laqc13c76pp29agrp";

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkgconfig cmake ];

  meta = with lib; {
    description = "Authentication client/server for Intecture components";
    homepage = https://intecture.io;
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
