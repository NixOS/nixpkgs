{ lib, buildGoPackage, fetchFromGitHub, makeWrapper }:

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
    install -D -t $out/share/tewisay/cows go/src/${goPackagePath}/cows/*.cow
  '';

  preFixup = ''
    wrapProgram $out/bin/tewisay \
      --prefix COWPATH : $out/share/tewisay/cows
  '';

  meta = with lib; {
    homepage = "https://github.com/lucy/tewisay";
    description = "Cowsay replacement with unicode and partial ansi escape support";
    license = licenses.cc0;
    maintainers = with maintainers; [ Madouura ];
  };
}
