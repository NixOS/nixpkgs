{ lib
, rustPlatform
, fetchFromGitHub
, coreutils
, pkg-config
, openssl
, pam
, openssh
}:

rustPlatform.buildRustPackage rec {
  pname = "pam_rssh";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "z4yx";
    repo = "pam_rssh";
    rev = "v${version}";
    hash = "sha256-SDtMqGy2zhq9jEQVwSEl4EwRp2jgXfTVLrCX7k/kBeU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-gNy1tcHDUOG1XduGAIMapvx5dlq+U1LitUQkccGfb9o=";

  postPatch = ''
    substituteInPlace src/auth_keys.rs \
      --replace '/bin/echo' '${coreutils}/bin/echo' \
      --replace '/bin/false' '${coreutils}/bin/false'
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    pam
  ];

  checkFlags = [
    # Fails because it tries finding authorized_keys in /home/$USER.
    "--skip=tests::parse_user_authorized_keys"
  ];

  nativeCheckInputs = [
    openssh
  ];

  env.USER = "nixbld";

  # Copied from https://github.com/z4yx/pam_rssh/blob/main/.github/workflows/rust.yml.
  preCheck = ''
    export HOME=$(mktemp -d)
    mkdir $HOME/.ssh
    ssh-keygen -q -N "" -t ecdsa -b 521 -f $HOME/.ssh/id_ecdsa521
    ssh-keygen -q -N "" -t ecdsa -b 384 -f $HOME/.ssh/id_ecdsa384
    ssh-keygen -q -N "" -t ecdsa -b 256 -f $HOME/.ssh/id_ecdsa256
    ssh-keygen -q -N "" -t ed25519 -f $HOME/.ssh/id_ed25519
    ssh-keygen -q -N "" -t rsa -f $HOME/.ssh/id_rsa
    ssh-keygen -q -N "" -t dsa -f $HOME/.ssh/id_dsa
    export SSH_AUTH_SOCK=$HOME/ssh-agent.sock
    eval $(ssh-agent -a $SSH_AUTH_SOCK)
    ssh-add $HOME/.ssh/id_ecdsa521
    ssh-add $HOME/.ssh/id_ecdsa384
    ssh-add $HOME/.ssh/id_ecdsa256
    ssh-add $HOME/.ssh/id_ed25519
    ssh-add $HOME/.ssh/id_rsa
    ssh-add $HOME/.ssh/id_dsa
  '';

  meta = with lib; {
    description = "PAM module for authenticating via ssh-agent, written in Rust";
    homepage = "https://github.com/z4yx/pam_rssh";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kranzes ];
  };
}
