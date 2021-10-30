{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rshijack";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jpiwbjsYsb5scFbjtv2eTv6oo0HWWTYLpnpTZ8DEqb0=";
  };

  cargoSha256 = "sha256-biHDnLu7OiYpnwtmayk2m6QYvX51YUVJH2FGP4qo14Q=";

  meta = with lib; {
    description = "TCP connection hijacker";
    homepage = "https://github.com/kpcyrd/rshijack";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.unix;
  };
}
