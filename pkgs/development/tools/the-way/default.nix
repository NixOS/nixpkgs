{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lvkrfszmn594n9qkf518c38c0fwzm32y997wlf28l3hpj6yqddq";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin  [ AppKit Security ];

  cargoSha256 = "1aiyfsvmrqcmlw0z1944i9s5g3yxc39na5mf16pb9a4bhw8zcwjr";
  checkFlagsArray = stdenv.lib.optionals stdenv.isDarwin [ "--skip=copy" ];
  cargoParallelTestThreads = false;

  postInstall = ''
    $out/bin/the-way config default tmp.toml
    for shell in bash fish zsh; do
      THE_WAY_CONFIG=tmp.toml $out/bin/the-way complete $shell > the-way.$shell
      installShellCompletion the-way.$shell
    done
  '';

  meta = with lib; {
    description = "Terminal code snippets manager";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ numkem ];
  };
}
