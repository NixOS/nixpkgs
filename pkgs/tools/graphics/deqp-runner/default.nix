{ lib, fetchFromGitLab, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "deqp-runner";
  version = "0.16.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "anholt";
    repo = "deqp-runner";
    rev = "v${version}";
    hash = "sha256-Spx7Y0es+s3k2dod/kdEgypncED8mNR23uRdOOcLxJc=";
  };

  cargoHash = "sha256-G4fxtpIhwAVleJ+0rN1+ZhKWw7QbWTB5aLUa3EdFyvA=";

  meta = with lib; {
    description = "A VK-GL-CTS/dEQP wrapper program to parallelize it across CPUs and report results against a baseline";
    homepage = "https://gitlab.freedesktop.org/anholt/deqp-runner";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Benjamin-L ];
  };
}
