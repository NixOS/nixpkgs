{ stdenv
, lib
, pkg-config
, rustPlatform
, fetchFromGitHub
, installShellFiles
, withNativeTls ? true
, Security
, libiconv
, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "xh";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = "xh";
    rev = "v${version}";
    sha256 = "sha256-y+Bixr+WRoTGjenkHSLbVmb9IHr9nicrAWyvkg5ey8E=";
  };

  cargoSha256 = "sha256-wyK10D9MMyNF+JSacWW6GQcaMYMbDf1PHhuZ5LwZo+I=";

  buildFeatures = lib.optional withNativeTls "native-tls";

  nativeBuildInputs = [ installShellFiles pkg-config ];

  buildInputs = lib.optionals withNativeTls
    (if stdenv.isDarwin then [ Security libiconv ] else [ openssl ]);

  # Get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  postInstall = ''
    installShellCompletion --cmd xh \
      --bash completions/xh.bash \
      --fish completions/xh.fish \
      --zsh completions/_xh

    installManPage doc/xh.1
    ln -s $out/share/man/man1/xh.1 $out/share/man/man1/xhs.1

    install -m444 -Dt $out/share/doc/xh README.md CHANGELOG.md

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
