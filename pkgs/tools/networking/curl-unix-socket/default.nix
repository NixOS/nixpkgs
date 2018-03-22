{ stdenv, fetchFromGitHub, go }:

stdenv.mkDerivation {
  name = "curl-unix-socket-2014-09-01";

  src = fetchFromGitHub {
    owner = "Soulou";
    repo = "curl-unix-socket";
    rev = "e926dca77ba7d4a1eeae073918fdd3db92f1a350";
    sha256 = "1ynrrav90y3dhk8jq2fxm3jswj5nvrffwslgykj429hk6n0czb3d";
  };

  buildInputs = [ go ];
  buildPhase = "go build -o curl-unix-socket";
  installPhase = "install -D curl-unix-socket $out/bin/curl-unix-socket";

  meta = with stdenv.lib; {
    description = "Run HTTP requests over UNIX socket";
    license = licenses.mit;
    homepage = https://github.com/Soulou/curl-unix-socket;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
