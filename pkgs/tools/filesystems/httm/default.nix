{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    rev = version;
    sha256 = "sha256-LJFBridWS7YYO9Bw3mzRdRnh2gGUxAtuoNq2T1wuAcY=";
  };

  cargoSha256 = "sha256-/v0QQ3EnmL1EKEjJ4O0t52SOrCz+CVBpunogEfVMpBw=";

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
