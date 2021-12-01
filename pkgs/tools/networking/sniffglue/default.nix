{ lib, fetchFromGitHub, rustPlatform, libpcap, libseccomp, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-s+2YzfSy7+o0VZZ4j/Cfd6F5GvBytthmDJqrPw+7SU0=";
  };

  cargoSha256 = "sha256-4G1OGY7/vE8NKBFeuOZzqyZ0DQN4hy/HBO9qrEtBYlM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap libseccomp ];

  meta = with lib; {
    description = "Secure multithreaded packet sniffer";
    homepage = "https://github.com/kpcyrd/sniffglue";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
