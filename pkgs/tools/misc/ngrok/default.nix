{ stdenv, fetchurl, go, git, mercurial, bazaar, cacert }:

stdenv.mkDerivation rec {
  name = "ngrok-${version}";
  version = "1.6";

  src = fetchurl {
    url = "https://github.com/inconshreveable/ngrok/archive/${version}.tar.gz";
    sha256 = "0w54ck00ma8wd87gc3dligypdjs7vrzbi9py46sqphsid3rihkjr";
  };

  buildInputs = [ go git mercurial bazaar ];

  GIT_SSL_CAINFO = "${cacert}/etc/ca-bundle.crt";

  preBuild = ''
    export HOME="$PWD"
  '';

  installPhase = ''
    make release-client
    mkdir -p $out/bin
    cp bin/ngrok $out/bin
    cp -R assets $out/
  '';

  meta = with stdenv.lib; {
    description = "Reverse proxy that creates a secure tunnel between from a public endpoint to a locally running web service";
    homepage = https://ngrok.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ iElectric ];
    platforms = stdenv.lib.platforms.all;
  };
}
