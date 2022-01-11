{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, bzip2
, stdenv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "pactorio";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tRmchXDg8flvByjg6GLwwdwQgp/5NdZIgnjYgPLcLP8=";
  };

  cargoSha256 = "sha256-FIn+6wflDAjshP2Vz/rXRTrrjPQFW63XtXo8hBHMdkg=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ bzip2 ] ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    completions=($releaseDir/build/pactorio-*/out/completions)
    installShellCompletion $completions/pactorio.{bash,fish} --zsh $completions/_pactorio
  '';

  GEN_COMPLETIONS = 1;

  meta = with lib; {
    description = "Mod packager for factorio";
    homepage = "https://github.com/figsoda/pactorio";
    changelog = "https://github.com/figsoda/pactorio/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
