{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    rev = version;
    sha256 = "sha256-FgVXl986PPaX/6TX7MaXPd+NJ3M94fNGa1hFWUDRP8w=";
  };

  cargoHash = "sha256-uWKSO2odvBeFUcZPGcsEki0PdNVtbVv5g3Dnkxgw2Io=";

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
