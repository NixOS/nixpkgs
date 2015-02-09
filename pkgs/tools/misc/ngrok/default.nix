{ stdenv, git, fetchFromGitHub, goPackages }:

with goPackages;

buildGoPackage rec {
  name = "ngrok-1.7";
  goPackagePath = "ngrok";

  src = fetchFromGitHub {
    rev = "b7d5571aa7f12ac304b8f8286b855cc64dd9bab8";
    owner = "inconshreveable";
    repo = "ngrok";
    sha256 = "0a5iq9l9f2xdg6gnc9pj0iczhycv1w5iwcqgzzap83xfpy01xkh4";
  };

  subPackages = [ "main/ngrok" "main/ngrokd" ];

  preConfigure = ''
    sed -e '/jteeuwen\/go-bindata/d' \
        -e '/export GOPATH/d' \
        -e 's/go get/#go get/' \
        -e 's|bin/go-bindata|go-bindata|' -i Makefile
    make assets BUILDTAGS=release
    export sourceRoot=$sourceRoot/src/ngrok
  '';

  buildInputs = [ git log4go websocket go-vhost mousetrap termbox-go rcrowley.go-metrics
                  yaml-v1 go-bindata go-update binarydist osext ];

  buildFlags = "-tags release";

  dontInstallSrc = true;

  meta = with stdenv.lib; {
    description = "Reverse proxy that creates a secure tunnel between from a public endpoint t
o a locally running web service";
    homepage = https://ngrok.com/;
    license = licenses.asl20;
    maintainers = with maintainers; [ iElectric cstrahan ];
    platforms = with platforms; linux ++ darwin;
  };

}
