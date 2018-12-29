{ stdenv
, buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "miniflux";
  version = "2.0.13";

  goPackagePath = "miniflux.app";

  src = fetchFromGitHub {
    owner = "miniflux";
    repo = "miniflux";
    rev = "refs/tags/${version}";
    sha256 = "16c9jszrz3153kr0xyj7na09hpqvnjsrmsbic7qkp5a9aa839b9s";
  };
    
  goDeps = ./deps.nix;

  doCheck = true;

  buildFlagsArray = ''
    -ldflags=-X ${goPackagePath}/version.Version=${version}
  '';

  postInstall = ''
    mv $bin/bin/miniflux.app $bin/bin/miniflux
  '';

  meta = with stdenv.lib; {
    description = "Minimalist and opinionated feed reader";
    homepage = https://miniflux.app/;
    license = licenses.asl20;
    maintainers = with maintainers; [ benpye ];
  };
}

