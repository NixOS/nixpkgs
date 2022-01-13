{ rustPlatform, fetchFromGitHub, lib, openssl, pkg-config, just, pandoc, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "dog-dns";
  version = "unstable-2021-10-07";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = "dog";
    rev = "721440b12ef01a812abe5dc6ced69af6e221fad5";
    sha256 = "sha256-y3T0vXg7631FZ4bzcbQjz3Buui/DFxh9LG8BZWwynp0=";
  };

  cargoSha256 = "sha256-3SiTA9MQ73laaURKWi+w30aH845iFiUCBS0t/UZe5jg=";

  outputs = [ "out" "man" ];

  nativeBuildInputs = [ pkg-config just pandoc installShellFiles ];
  buildInputs = [ openssl ];

  postBuild = ''
    just man
  '';

  postInstall = ''
    installManPage ./target/man/*.1

    for sh in bash zsh fish; do
      installShellCompletion --cmd dog ./completions/dog."$sh"
    done
  '';

  meta = with lib; {
    description = "A command-line DNS client";
    homepage = "https://github.com/ogham/dog";
    license = licenses.eupl12;
    maintainers = with maintainers; [ ma27 ];
    mainProgram = "dog";
  };
}
