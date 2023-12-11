{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, bzip2
, xz
, zlib
, zstd
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "ouch";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ouch-org";
    repo = "ouch";
    rev = version;
    hash = "sha256-WqV04GhX7lIla5BEdHRgRZsAWBSweb1HFAC9XZYqpYo=";
  };

  cargoHash = "sha256-A3YcgHed5mp7//FMoC/02KAU7Y+7YiG50eWE9tP5mF8=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = [ bzip2 xz zlib zstd ];

  buildFeatures = [ "zstd/pkg-config" ];

  preCheck = ''
    substituteInPlace tests/ui.rs \
      --replace 'format!(r"/private{path}")' 'path.to_string()'
  '';

  postInstall = ''
    installManPage artifacts/*.1
    installShellCompletion artifacts/ouch.{bash,fish} --zsh artifacts/_ouch
  '';

  env = { OUCH_ARTIFACTS_FOLDER = "artifacts"; } //
    # Work around https://github.com/NixOS/nixpkgs/issues/166205.
    lib.optionalAttrs stdenv.cc.isClang { NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}"; };

  meta = with lib; {
    description = "A command-line utility for easily compressing and decompressing files and directories";
    homepage = "https://github.com/ouch-org/ouch";
    changelog = "https://github.com/ouch-org/ouch/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda psibi ];
    mainProgram = "ouch";
  };
}
