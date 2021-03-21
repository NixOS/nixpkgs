{ stdenv, lib, openssl, pkg-config, rustPlatform, fetchFromGitHub, Security
, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xh";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = "xh";
    rev = "v${version}";
    sha256 = "pRVlcaPfuO7IMH2p0AQfVrCIXCRyF37WIirOJQkcAJE=";
  };

  cargoSha256 = "dXo1+QvCW3CWN2OhsqGh2Q1xet6cmi2xVy1Xk7s1YR8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = if stdenv.isDarwin then [ Security libiconv ] else [ openssl ];

  # Get openssl-sys to use pkg-config
  OPENSSL_NO_VENDOR = 1;

  checkFlagsArray = [ "--skip=basic_options" ];

  # Nix build happens in sandbox without internet connectivity
  # disable tests as some of them require internet due to nature of application
  doCheck = false;
  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/xh --help > /dev/null
  '';

  meta = with lib; {
    description = "Yet another HTTPie clone in Rust";
    homepage = "https://github.com/ducaale/xh";
    changelog = "https://github.com/ducaale/xh/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ payas SuperSandro2000 ];
  };
}
