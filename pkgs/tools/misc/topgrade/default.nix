{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pqf7rs9b8j54rwg8i8alvf65c4jfp5q2hv3yr60aiidfjrawp34";
  };

  cargoSha256 = "1wh7xywp92h3in9a2nr6sia6l3852kw4s688sr1c2wjdf2i58lsg";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne hugoreeves ];
  };
}
