{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pam,
  pkg-config,
}:
rustPlatform.buildRustPackage rec {
  pname = "pam_rssh";
  version = "unstable-2023-01-12";

  src = fetchFromGitHub {
    owner = "z4yx";
    repo = pname;
    rev = "773823b9a8605436e5bcfabd1c3ff8deb8503f43";
    hash = "sha512-rAr4ugo+IaxOKXtfEq9stK4edodork2uz10trHDv9MN4Oc296uDQjLh8Sle04Z4mbW56rWlT8eHrW6YpqGHFpw==";
    fetchSubmodules = true;
  };

  cargoHash = "sha512-gSZ2EAhFJ1XqYmrVqJm3QP0l433XQxvkstkvyDAFZXB6KXiGzN0EoFxYoTdD0q2fE3tr5EBlmm4iC/Jo3wi4sg==";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    pam
  ];

  doCheck = false;
  # How do disable specific tests?
  # checkFlags = [
  #   # Expects $USER and $SSH_AUTH_SOCK
  #   "--skip=lib::tests::sshagent_list_identities"
  #   "--skip=lib::tests::sshagent_auth"
  #   "--skip=lib::tests::sshagent_more_auth"
  #   "--skip=lib::tests::parse_user_authorized_keys"
  # ];

  meta = with lib; {
    description = "Remote sudo authenticated via ssh-agent";
    homepage = "https://github.com/z4yx/pam_rssh";
    license = licenses.mit;
    maintainers = with maintainers; [jamiemagee];
  };
}
