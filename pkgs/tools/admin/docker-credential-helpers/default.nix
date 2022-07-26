{ lib, stdenv, buildGoPackage, fetchFromGitHub, pkg-config, libsecret }:

buildGoPackage rec {
  pname = "docker-credential-helpers";
  version = "0.6.3";

  goPackagePath = "github.com/docker/docker-credential-helpers";

  src = fetchFromGitHub {
    owner = "docker";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xgmwjva3j1s0cqkbajbamj13bgzh5jkf2ir54m9a7w8gjnsh6dx";
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ libsecret ];

  buildPhase =
    if stdenv.isDarwin
    then ''
      cd go/src/${goPackagePath}
      go build -ldflags -s -o bin/docker-credential-osxkeychain osxkeychain/cmd/main_darwin.go
    ''
    else ''
      cd go/src/${goPackagePath}
      go build -o bin/docker-credential-secretservice secretservice/cmd/main_linux.go
      go build -o bin/docker-credential-pass pass/cmd/main_linux.go
    '';

  installPhase =
    if stdenv.isDarwin
    then ''
      install -Dm755 -t $out/bin bin/docker-credential-osxkeychain
    ''
    else ''
      install -Dm755 -t $out/bin bin/docker-credential-pass
      install -Dm755 -t $out/bin bin/docker-credential-secretservice
    '';

  meta = with lib; {
    description = "Suite of programs to use native stores to keep Docker credentials safe";
    homepage = "https://github.com/docker/docker-credential-helpers";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.linux ++ platforms.darwin;
  } // lib.optionalAttrs stdenv.isDarwin {
    mainProgram = "docker-credential-osxkeychain";
  };
}
