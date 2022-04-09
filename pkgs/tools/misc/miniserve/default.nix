{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, zlib
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "miniserve";
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "miniserve";
    rev = "v${version}";
    hash = "sha256-JlpjDUX8v7sGADhdKNQXoklbl/fw8DT0A6hEaUG61TQ=";
  };

  cargoSha256 = "sha256-5V8+Mcuu3fxG399QjW++/uWpPMvVWBfhI/L/6pmbkVY=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    zlib
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  checkFlags = [
    "--skip=bind_ipv4_ipv6::case_2"
    "--skip=cant_navigate_up_the_root"
  ];

  postInstall = ''
    installShellCompletion --cmd miniserve \
      --bash <($out/bin/miniserve --print-completions bash) \
      --fish <($out/bin/miniserve --print-completions fish) \
      --zsh <($out/bin/miniserve --print-completions zsh)
  '';

  meta = with lib; {
    description = "CLI tool to serve files and directories over HTTP";
    homepage = "https://github.com/svenstaro/miniserve";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
    # https://hydra.nixos.org/build/162650896/nixlog/1
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
