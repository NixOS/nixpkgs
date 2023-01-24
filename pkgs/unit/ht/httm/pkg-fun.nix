{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    rev = version;
    sha256 = "sha256-TDA1T36iY3xRFX0mBYazKeyzoDD7RPWRxQfUF7Rv5vA=";
  };

  cargoHash = "sha256-rBZ9cYk5Gzs8hy8fRgO8I0zaBncl8CwQoX5I0qzHBYE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage httm.1

    installShellCompletion --cmd httm \
      --zsh scripts/httm-key-bindings.zsh
  '';

  meta = with lib; {
    description = "Interactive, file-level Time Machine-like tool for ZFS/btrfs";
    homepage = "https://github.com/kimono-koans/httm";
    changelog = "https://github.com/kimono-koans/httm/releases/tag/${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ wyndon ];
  };
}
