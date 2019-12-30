{ stdenv, fetchFromGitHub, rustPlatform }:

with rustPlatform;

buildRustPackage rec {
  pname = "what";
  version = "0.5.1";

  cargoSha256 = "1rixpljqddwhryddzni5l6m4sjyn1krrj0ig0rzc701am7srhg3a";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = "what";
    rev = "${version}";
    sha256 = "1q926w6c4hhf6gim6dn3jfcibgj5zbsgwnf5crmh8wv6a8fg6pxg";
  };

  meta = with stdenv.lib; {
    description = "A CLI utility for displaying current network utilization by process, connection and remote IP/hostname";
    homepage = https://github.com/imsnif/what;
    license = licenses.mit;
    maintainers = with maintainers; [ fadenb ];
  };
}
