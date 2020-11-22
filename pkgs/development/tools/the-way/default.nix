{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = pname;
    rev = "v${version}";
    sha256 = "1h4lmlmkf7ji5smfrnlda1g3n0r5zjag4dqhr33v64qgh5ddhmlg";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin  [ AppKit Security ];

  cargoSha256 = "1v6kllyqa4x9hvpyypn1varixpdml8pllkrm8n1fs4l9rb7fd8yd";
  checkFlagsArray = stdenv.lib.optionals stdenv.isDarwin [ "--skip=copy" ];
  cargoParallelTestThreads = false;

  postInstall = ''
    $out/bin/the-way config default tmp.toml
    for shell in bash fish zsh; do
      THE_WAY_CONFIG=tmp.toml $out/bin/the-way complete $shell > the-way.$shell
      installShellCompletion the-way.$shell
    done
  '';

  meta = with stdenv.lib; {
    description = "Terminal code snippets manager";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ numkem ];
  };
}
