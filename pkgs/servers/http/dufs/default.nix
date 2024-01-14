{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "dufs";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "sigoden";
    repo = "dufs";
    rev = "v${version}";
    hash = "sha256-YPEJP+RdGxEMVRoDohxGiOkOMmWLhlBrkr+T+zcST5g=";
  };

  cargoHash = "sha256-Dia0/yV2rsUx0Mfd2rQkNh7QB+dZubudcoyfMmeaxx8=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # FIXME: checkPhase on darwin will leave some zombie spawn processes
  # see https://github.com/NixOS/nixpkgs/issues/205620
  doCheck = !stdenv.isDarwin;
  checkFlags = [
    # tests depend on network interface, may fail with virtual IPs.
    "--skip=validate_printed_urls"
  ];

  postInstall = ''
    installShellCompletion --cmd dufs \
      --bash <($out/bin/dufs --completions bash) \
      --fish <($out/bin/dufs --completions fish) \
      --zsh <($out/bin/dufs --completions zsh)
  '';

  meta = with lib; {
    description = "A file server that supports static serving, uploading, searching, accessing control, webdav";
    homepage = "https://github.com/sigoden/dufs";
    changelog = "https://github.com/sigoden/dufs/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda holymonson ];
  };
}
