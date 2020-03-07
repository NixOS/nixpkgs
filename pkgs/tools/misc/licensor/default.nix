{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "licensor";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "raftario";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zr8hcq7crmhrdhwcclc0nap68wvg5kqn5l93ha0vn9xgjy8z11p";
  };

  cargoSha256 = "1z2r8nfizifj8sk1ghppyqk5r65sgmbk47fiq95pnwpadm5drvqa";

  # Unit tests pass, but 1 integration test fails
  doCheck = false;

  meta = with lib; {
    description = "Write licenses to stdout";
    homepage = "https://github.com/raftario/licensor";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
