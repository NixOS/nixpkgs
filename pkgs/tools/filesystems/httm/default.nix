{ lib
, fetchFromGitHub
, rustPlatform
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "httm";
  version = "0.10.16";

  src = fetchFromGitHub {
    owner = "kimono-koans";
    repo = pname;
    rev = version;
    sha256 = "09zdexeMu54Y/4HbieZ0EJLxhwCv7upRJxqVbqr2hUw=";
  };

  cargoSha256 = "SLEp88KwRg1RN78oX+fMYNR6ia9omrfH2bnJb+PrTAY=";

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
