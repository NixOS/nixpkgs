{ lib
, rustPlatform
, fetchFromGitHub
, help2man
, installShellFiles
, pkg-config
, bzip2
, xz
, zlib
, zstd
}:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = pname;
    rev = version;
    sha256 = "sha256-XB0J7Qeru+FX5YprepglfTndS8b3zsAw1b9mc4n6EdA=";
  };

  cargoSha256 = "sha256-aW1aDXxs64ScocrnlsGy2+NAs6aC8F0/S1f32f9BDJU=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ bzip2 xz zlib zstd ];

  buildFeatures = [ "zstd/pkg-config" ];

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/ouch.{bash,fish} --zsh artifacts/_ouch
  '';

  OUCH_ARTIFACTS_FOLDER = "artifacts";

  meta = with lib; {
    description = "A command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    changelog = "https://github.com/ouch-org/ouch/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda psibi ];
  };
}
