{ lib, fetchFromGitHub, rustPlatform, libpcap, libseccomp, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vyxlqwh90shihp80fk0plnkjix9i37n2dnypzyz6nx44xd5737s";
  };

  cargoSha256 = "162p3a696k281cygqpl6gg4makwk2v0g2jnf1gd108dnz4jya11l";

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
