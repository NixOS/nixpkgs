{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "loop";
  version = "unstable-2020-07-08";

  src = fetchFromGitHub {
    owner = "Miserlou";
    repo  = "Loop";
    rev   = "944df766ddecd7a0d67d91cc2dfda8c197179fb0";
    sha256 = "0v61kahwk1kdy8pb40rjnzcxby42nh02nyg9jqqpx3vgdrpxlnix";
  };

  cargoSha256 = "05h9jy5n3mxjqb4aaap9gkimd5cv33pb6haiabxmhlwz6mnf7hq0";

  meta = with lib; {
    description = "UNIX's missing `loop` command";
    homepage = "https://github.com/Miserlou/Loop";
    maintainers = with maintainers; [ koral ];
    license = licenses.mit;
  };
}
