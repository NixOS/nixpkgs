{ stdenv, lib
, fetchFromGitHub, gprolog }:

stdenv.mkDerivation rec {
  pname = "profetch";
  version = "v0.1.6";

  src = fetchFromGitHub {
    owner = "RustemB";
    repo = "profetch";
    rev = "v0.1.6";
    sha256 = "1clh3l50wz6mlrw9kx0wh2bbhnz6bsksyh4ngz7givv4y3g9m702";
  };

  buildInputs = [ gprolog ];

  buildPhase = ''
    gplc profetch.pl --no-top-level            \
                     --no-debugger --no-fd-lib \
                     --no-fd-lib-warn --min-size -o profetch
  '';

  installPhase = ''
    install -Dm755 -t $out/bin profetch
  '';

  meta = with lib; {
    description = "System Information Fetcher Written in GNU/Prolog";
    homepage = "https://github.com/RustemB/profetch";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.vel ];
  };
}
