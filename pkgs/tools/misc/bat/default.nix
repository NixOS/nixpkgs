{ stdenv, pkgs, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  name    = "bat-${version}";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner  = "sharkdp";
    repo   = "bat";
    rev    = "v${version}";
    sha256 = "0qbjkrakcpvnzzljifykw88g0qmmk60id23sjvhp4md54h4xg29p";
  };

  cargoSha256 = "07r10wwxv8svrw94djl092zj512868izlxldsiljfj34230abl02";

  buildInputs = with pkgs; [ openssl pkgconfig cmake zlib file perl curl ];

  meta = with stdenv.lib; {
    description = "A cat(1) clone with syntax highlighting and Git integration";
    homepage    = https://github.com/sharkdp/bat;
    license     = licenses.mit;
    maintainers = [];
    platforms   = platforms.linux;
  };
}
