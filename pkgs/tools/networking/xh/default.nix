{ stdenv, lib, openssl, pkg-config, rustPlatform, fetchFromGitHub, Security
, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "xh";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = "xh";
    rev = "v${version}";
    sha256 = "cOlya3ngIoaoqzh0fIbNAjwO7S7wZCQk7WVqgZona8A=";
  };

  cargoSha256 = "5B2fY+S9z6o+CHCIK93+Yj8dpaiQi4PSMQw1mfXg1NA=";

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
