{ stdenv, lib, rustPlatform, fetchFromGitHub, Security }:

rustPlatform.buildRustPackage rec {
  pname = "xh";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ducaale";
    repo = "xh";
    rev = "v${version}";
    sha256 = "0b7q0xbfbrhvpnxbm9bd1ncdza9k2kcmcir3qhqzb2pgsb5b5njx";
  };

  cargoSha256 = "02fgqys9qf0jzs2n230pyj151v6xbm6wm2rd9qm5gsib6zaq7gfa";

  buildInputs = lib.optional stdenv.isDarwin Security;

  checkFlagsArray = [ "--skip=basic_options" ];

  doInstallCheck = true;
  postInstallCheck = ''
    $out/bin/xh --help > /dev/null
  '';

  meta = with lib; {
    description = "Yet another HTTPie clone in Rust";
    homepage = "https://github.com/ducaale/xh";
    license = licenses.mit;
    maintainers = with maintainers; [ payas SuperSandro2000 ];
  };
}
