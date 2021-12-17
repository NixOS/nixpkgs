{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "fend";
  version = "0.1.26";

  src = fetchFromGitHub {
    owner = "printfn";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U5LYjoq11qZYus/McDbtVljj2RSP9MCXXDvOWgbXerk=";
  };

  cargoSha256 = "sha256-E7by7FJfmOBqDoZLA9s/bj/EHaZ4IsHYTHWcvIuaMNg=";

  doInstallCheck = true;

  installCheckPhase = ''
    [[ "$($out/bin/fend "1 km to m")" = "1000 m" ]]
  '';

  meta = with lib; {
    description = "Arbitrary-precision unit-aware calculator";
    homepage = "https://github.com/printfn/fend";
    license = licenses.mit;
    maintainers = with maintainers; [ djanatyn ];
  };
}
