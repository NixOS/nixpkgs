{ lib, fetchFromGitHub, rustPlatform, libpcap, libseccomp, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lkz25z0qy1giss4rnhkx9fvsdd8ckf4z1gqw46zl664x96bb705";
  };

  cargoSha256 = "01ya9535whi2kviw57f25n8h05ckpb4bq1h7qav6srai97rm937s";

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libpcap libseccomp ];

  meta = with lib; {
    description = "Secure multithreaded packet sniffer";
    homepage = "https://github.com/kpcyrd/sniffglue";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
