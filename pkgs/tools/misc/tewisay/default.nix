{ stdenv, buildGoPackage, fetchFromGitHub, makeWrapper }:

buildGoPackage rec {
  pname = "tewisay-unstable";
  version = "2017-04-14";

  goPackagePath = "github.com/lucy/tewisay";

  src = fetchFromGitHub {
    owner = "lucy";
    repo = "tewisay";
    rev = "e3fc38737cedb79d93b8cee07207c6c86db4e488";
    sha256 = "1na3xi4z90v8qydcvd3454ia9jg7qhinciy6kvgyz61q837cw5dk";
  };

  nativeBuildInputs = [ makeWrapper ];

  goDeps = ./deps.nix;

  postInstall = ''
    install -D -t $bin/share/tewisay/cows go/src/${goPackagePath}/cows/*.cow
  '';

  preFixup = ''
    wrapProgram $bin/bin/tewisay \
      --prefix COWPATH : $bin/share/tewisay/cows
  '';

  meta = {
    homepage = https://github.com/lucy/tewisay;
    description = "Cowsay replacement with unicode and partial ansi escape support";
    license = stdenv.lib.licenses.cc0;
    maintainers = [ stdenv.lib.maintainers.chiiruno ];
    platforms = stdenv.lib.platforms.all;
  };
}
