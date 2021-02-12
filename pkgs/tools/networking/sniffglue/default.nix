{ lib, fetchFromGitHub, rustPlatform, libpcap, libseccomp, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lkz25z0qy1giss4rnhkx9fvsdd8ckf4z1gqw46zl664x96bb705";
  };

  cargoSha256 = "139l4x9lj4cj7fpqyp6gp1n1g4i8pc5ai3yl8fa8ijs39jjrshv5";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap libseccomp ];

  meta = with lib; {
    description = "Secure multithreaded packet sniffer";
    homepage = "https://github.com/kpcyrd/sniffglue";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
