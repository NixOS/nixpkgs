{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, Security }:

rustPlatform.buildRustPackage rec {
  pname = "shadowenv";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = pname;
    rev = version;
    sha256 = "1h8hfyxxl4bpx8azzxj0snmzccn6xjd9vc2iyp8i2ar7aiyhf5yd";
  };

  cargoSha256 = "1bjkwn57vm3in8lajhm7p9fjwyqhmkrb3fyq1k7lqjvrrh9jysb2";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  postInstall = ''
    installManPage man/man1/shadowenv.1
    installManPage man/man5/shadowlisp.5
    installShellCompletion --bash sh/completions/shadowenv.bash
    installShellCompletion --fish sh/completions/shadowenv.fish
    installShellCompletion --zsh sh/completions/_shadowenv
  '';

  meta = with stdenv.lib; {
    homepage = "https://shopify.github.io/shadowenv/";
    description = "reversible directory-local environment variable manipulations";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
