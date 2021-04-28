{ lib, rustPlatform, fetchFromGitHub, shared-mime-info }:

rustPlatform.buildRustPackage rec {
  pname = "handlr";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OtU6sL2Bbbec0gHxk3bl5Inn+ZmNYiHgpSF0gjDuRSg=";
  };

  cargoSha256 = "sha256-bX7QWV1R+pLxvghpaV10LeROv4wBVfZhHyrPCIgqETA=";

  nativeBuildInputs = [ shared-mime-info ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  meta = with lib; {
    description = "Alternative to xdg-open to manage default applications with ease";
    homepage = "https://github.com/chmln/handlr";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
