{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "dura";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "tkellogg";
    repo = "dura";
    rev = "v${version}";
    sha256 = "sha256-xAcFk7z26l4BYYBEw+MvbG6g33MpPUvnpGvgmcqhpGM=";
  };

  cargoSha256 = "sha256-XOtPtOEKZMJzNeBZBT3Mc/KOjMOcz71byIv/ftcRP48=";

  cargoPatches = [
    ./Cargo.lock.patch
  ];

  doCheck = false;

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "A background process that saves uncommited changes on git";
    longDescription = ''
      Dura is a background process that watches your Git repositories and
      commits your uncommitted changes without impacting HEAD, the current
      branch, or the Git index (staged files). If you ever get into an
      "oh snap!" situation where you think you just lost days of work,
      checkout a "dura" branch and recover.
    '';
    homepage = "https://github.com/tkellogg/dura";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ drupol ];
  };
}
