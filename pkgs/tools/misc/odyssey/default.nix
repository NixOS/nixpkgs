{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "odyssey";
  version = "1.0rc1";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = pname;
    rev = version;
    sha256 = "0p9zzazx3bhwz7sz8l757lwdj8qx0ij2k3g0d12prs0xfi1qhcmz";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

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
