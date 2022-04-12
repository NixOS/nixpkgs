{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, rustPlatform
, libiconv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nrWsEPYW4R5P8KUh4R3cZ4VFO9zoID0cl6lz7nNjnp0=";
  };

  cargoSha256 = "sha256-sWVMPjG5ZqAKr7BmMJdBnVmBDr1MWl3hhmOBxQJexJY=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  postInstall = ''
    HOME=$(mktemp -d)
    for shell in bash fish zsh; do
      $out/bin/atuin gen-completions -s $shell -o .
    done

    installShellCompletion --cmd atuin \
      --bash atuin.bash \
      --fish atuin.fish \
      --zsh _atuin
  '';

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/ellie/atuin";
    license = licenses.mit;
    maintainers = with maintainers; [ onsails SuperSandro2000 sciencentistguy ];
  };
}
