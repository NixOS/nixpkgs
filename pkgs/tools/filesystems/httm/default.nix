{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.10.15";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    rev = version;
    sha256 = "u18dIw4At78OSeWCDHJIjzDbaxpiSs3g+bf2WClFkuY=";
  };

  cargoSha256 = "mLFponkRIEWePpSyhQK1IG/rnJ0qpDwrS7vwAoP1ro0=";

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
