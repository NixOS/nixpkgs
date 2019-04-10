{ buildGoPackage, stdenv, fetchFromGitHub }:

buildGoPackage rec {
  name = "curl-unix-socket-2015-04-10";

  src = fetchFromGitHub {
    owner = "Soulou";
    repo = "curl-unix-socket";
    rev = "a7da90b01ed43e8c0d606f760c9da82f8e3ed307";
    sha256 = "1ynrrav90y3dhk8jq2fxm3jswj5nvrffwslgykj429hk6n0czb3d";
  };

  goPackagePath = "github.com/Soulou/curl-unix-socket";

  buildPhase = ''
    runHook preBuild
    (
      cd go/src/${goPackagePath}
      go build -o $NIX_BUILD_TOP/go/bin/curl-unix-socket
    )
    runHook postBuild
  '';

  meta = with stdenv.lib; {
    description = "Run HTTP requests over UNIX socket";
    license = licenses.mit;
    homepage = https://github.com/Soulou/curl-unix-socket;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
