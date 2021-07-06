{ lib, stdenv, rustPlatform, fetchFromGitHub, CoreServices, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "watchexec";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "1xznhfljvsvc0ykv5h1wg31n93v96lvhbxfhavxivq3b0xh5vxrw";
  };

  cargoSha256 = "00dampnsnpzmchjcn0j5zslx17i0qgrv99gq772n0683m1l2lfq3";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices libiconv ];

  postInstall = ''
    installManPage doc/watchexec.1
    installShellCompletion --zsh --name _watchexec completions/zsh
  '';

  meta = with lib; {
    description = "Executes commands in response to file modifications";
    homepage = "https://github.com/watchexec/watchexec";
    license = with licenses; [ asl20 ];
    maintainers = [ maintainers.michalrus ];
  };
}
