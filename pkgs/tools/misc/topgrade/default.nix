{ stdenv, lib, fetchFromGitHub, rustPlatform, Foundation, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "15ad30svvr775dxp5gwlq73xydsqwfpw650c3c3ma4jshw36w0x4";
  };

  cargoSha256 = "0bwy2y44czhvckipvjn28j6ds1pnbj38i29hvlv4f782imfn92hz";

  buildInputs = lib.optional stdenv.isDarwin Foundation;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Br1ght0ne hugoreeves ];
  };
}
