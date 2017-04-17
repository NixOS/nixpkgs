{ stdenv, lib, fetchFromGitHub, rustPlatform
, openssl, zeromq, czmq, pkgconfig, cmake, zlib }:

with rustPlatform;

buildRustPackage rec {
  name = "intecture-auth-${version}";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "intecture";
    repo = "auth";
    rev = version;
    sha256 = "1p3jahha8k139f22ijg050cl8akfzxda4gzvijpqv869hmhc70py";
  };

  depsSha256 = "0mki57yzb29y9fhh16xvpi5gfp6c14r5q3f45f3v8sdj95rjahz1";

  buildInputs = [ openssl zeromq czmq zlib ];

  nativeBuildInputs = [ pkgconfig cmake ];

  meta = with lib; {
    description = "Authentication client/server for Intecture components";
    homepage = https://intecture.io;
    license = licenses.mpl20;
    maintainers = [ maintainers.rushmorem ];
  };
}
