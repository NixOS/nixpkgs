{ lib, fetchFromGitHub, rustPlatform, libpcap, libseccomp, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8SkwdPaKHf0ZE/MeM4yOe2CpQvZzIHf5d06iM7KPAT8=";
  };

  cargoSha256 = "sha256-UGvFLW48sakNuV3eXBpCxaHOrveQPXkynOayMK6qs4g=";

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
