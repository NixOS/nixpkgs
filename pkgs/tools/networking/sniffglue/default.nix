{ lib, fetchFromGitHub, rustPlatform, libpcap, libseccomp, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "sniffglue";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bvLkeC5Hm1enaWJtYmnnINgpSO3tlg1SsEzeMSF9OXk=";
  };

  cargoSha256 = "sha256-dxE1o7JqGvWwOtuhHgq0t9Zw1wQt5lt1OJJY992jjjA=";

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
