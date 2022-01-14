{ lib, fetchFromGitHub, rustPlatform, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "dura";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "tkellogg";
    repo = "dura";
    rev = "v0.1.0";
    sha256 = "sha256-XnsR1oL9iImtj0X7wJ8Pp/An0/AVF5y+sD551yX4IGo=";
  };

  cargoSha256 = "sha256-+Tq0a5cs2XZoT7yzTf1oIPd3kgD6SyrQqxQ1neTcMwk=";

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
