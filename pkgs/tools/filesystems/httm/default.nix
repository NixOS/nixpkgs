{ lib, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    rev = version;
    sha256 = "L8yqf+QadN+uZxBjT3RWG7L3QqIerNrNc1u9PP1pt1I=";
  };

  cargoSha256 = "UxqgJBgKD7hGT0UjAVYqb+sjbZ1sYVVOQSDvRQROOso=";

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
