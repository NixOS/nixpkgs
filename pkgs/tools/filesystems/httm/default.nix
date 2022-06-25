{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    rev = version;
    sha256 = "2pShuWJns8VnxiRgj5GLv5Y7H5Qw/SfQ6lVo6VqyU/A=";
  };

  cargoSha256 = "x5JUwQxrZ5TBG8FAMlomTkZOCxV0c/7i5sx33BCUkKo=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage httm.1

    installShellCompletion --cmd httm \
      --zsh scripts/httm-key-bindings.zsh
  '';

  meta = with lib; {
    description = "Interactive, file-level Time Machine-like tool for ZFS/btrfs";
    homepage = "https://github.com/kimono-koans/httm";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wyndon ];
  };
}
