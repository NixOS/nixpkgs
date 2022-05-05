{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    rev = version;
    sha256 = "sha256-uqzwS7+OQsPdMv3+fWdn3yVFJwtFZNd8kVWw//mQZj8=";
  };

  cargoSha256 = "sha256-EC3E5NawsDe+CU5WEu0G3FWVLuqW5nXOoUURN0iDPK0=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage httm.1

    installShellCompletion --cmd httm \
      --zsh scripts/httm-key-bindings.zsh
  '';

  meta = with lib; {
    description = "Interactive, file-level ZFS Time Machine-like tool";
    homepage = "https://github.com/kimono-koans/httm";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wyndon ];
  };
}
