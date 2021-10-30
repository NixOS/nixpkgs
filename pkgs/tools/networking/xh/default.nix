{ stdenv, lib, openssl, pkg-config, rustPlatform, fetchFromGitHub, Security
, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "xh";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = "xh";
    rev = "v${version}";
    sha256 = "sha256-fTd4VSUUj9Im+kCEuFgDsA7eofM1xQfrRzigr1vyJ3I=";
  };

  cargoSha256 = "sha256-yZdGw/6iVg8PaUyjTrxj6h/2yhBtqEqvMhdRHhMwDZc=";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = if stdenv.isDarwin then [ Security libiconv ] else [ openssl ];

  # Get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  postInstall = ''
    installShellCompletion --cmd xh \
      --bash completions/xh.bash \
      --fish completions/xh.fish \
      --zsh completions/_xh

    # https://github.com/ducaale/xh#xh-and-xhs
    ln -s $out/bin/xh $out/bin/xhs
  '';

  # Nix build happens in sandbox without internet connectivity
  # disable tests as some of them require internet due to nature of application
  doCheck = false;
  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/xh --help > /dev/null
    $out/bin/xhs --help > /dev/null
  '';

  meta = with lib; {
    description = "Friendly and fast tool for sending HTTP requests";
    homepage = "https://github.com/ducaale/xh";
    changelog = "https://github.com/ducaale/xh/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ payas SuperSandro2000 ];
  };
}
