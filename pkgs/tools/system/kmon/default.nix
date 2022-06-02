{ lib, rustPlatform, fetchFromGitHub, installShellFiles, python3, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0sjRTbTLtBUTyx6+HnihL9TggoeIOqX9zKRaXjBUfE0=";
  };

  cargoSha256 = "sha256-QMJ3Rpgcfrza2zFiA5LFBuYedn+VnffzpyzAGeC0PSM=";

  nativeBuildInputs = [ installShellFiles python3 ];

  buildInputs = [ libxcb ];

  postInstall = ''
    installManPage man/kmon.8
  '';

  meta = with lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    changelog = "https://github.com/orhun/kmon/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ figsoda misuzu ];
  };
}
