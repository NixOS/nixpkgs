{ lib, fetchFromGitHub, rustPlatform, libpcap, libseccomp, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P8ubw523sw1O6Gpruy1Wa/Y0I3qJgvMdT53wBBoEGhE=";
  };

  cargoSha256 = "sha256-+Wh+/C9LvYppCghv11e8NKNhiMy0SV4S3nEWA6b1hQk=";

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
