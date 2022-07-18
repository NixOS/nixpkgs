{ lib, stdenv, fetchFromGitHub, cmake, openssl, postgresql, zstd }:

stdenv.mkDerivation rec {
  pname = "odyssey";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = pname;
    rev = version;
    sha256 = "sha256-1ALTKRjpKmmFcAuhmgpcbJBkNuUlTyau8xWDRHh7gf0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl postgresql zstd ];
  cmakeFlags = [ "-DPQ_LIBRARY=${postgresql.lib}/lib" ];

  installPhase = ''
    install -Dm755 -t $out/bin sources/odyssey
  '';

  meta = with lib; {
    description = "Scalable PostgreSQL connection pooler";
    homepage = "https://github.com/yandex/odyssey";
    license = licenses.bsd3;
    maintainers = [ maintainers.marsam ];
    platforms = [ "x86_64-linux" ];
  };
}
