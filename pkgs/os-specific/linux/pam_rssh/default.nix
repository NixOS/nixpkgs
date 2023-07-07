{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, pam
, openssh
}:

rustPlatform.buildRustPackage {
  pname = "pam_rssh";
  version = "unstable-2023-03-18";

  src = fetchFromGitHub {
    owner = "z4yx";
    repo = "pam_rssh";
    rev = "92c240bd079e9711c7afa8bacfcf01de48f42577";
    hash = "sha256-mIQeItPh6RrF3cFbAth2Kmb2E/Xj+lOgatvjcLE4Yag=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-/AQqjmAGgvnpVWyoK3ymZ1gNAhTSN30KQEiqv4G+zx8=";

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
