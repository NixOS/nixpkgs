{ buildGoPackage, go-bindata, fetchFromGitHub }:

buildGoPackage rec {
  name = "ngrok-${version}";
  version = "1.7.1";
  rev = "${version}";

  goPackagePath = "ngrok";

  src = fetchFromGitHub {
    inherit rev;
    owner = "inconshreveable";
    repo = "ngrok";
    sha256 = "1r4nc9knp0nxg4vglg7v7jbyd1nh1j2590l720ahll8a4fbsx5a4";
  };

  goDeps = ./deps.nix;

  buildInputs = [ go-bindata ];

  preConfigure = ''
    sed -e '/jteeuwen\/go-bindata/d' \
        -e '/export GOPATH/d' \
        -e 's/go get/#go get/' \
        -e 's|bin/go-bindata|go-bindata|' -i Makefile
    make assets BUILDTAGS=release
    export sourceRoot=$sourceRoot/src/ngrok
  '';

  buildFlags = [ "-tags release" ];

  meta = {
    homepage = https://ngrok.com/;
  };
}
