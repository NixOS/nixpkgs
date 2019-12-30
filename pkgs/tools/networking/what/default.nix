{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "what";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = version;
    sha256 = "1q926w6c4hhf6gim6dn3jfcibgj5zbsgwnf5crmh8wv6a8fg6pxg";
  };

  cargoSha256 = "1rixpljqddwhryddzni5l6m4sjyn1krrj0ig0rzc701am7srhg3a";

  meta = with lib; {
    description = "A CLI utility for displaying current network utilization";
    longDescription = ''
      what sniffs a given network interface and records IP packet size, cross
      referencing it with the /proc filesystem on linux or lsof on MacOS. It is
      responsive to the terminal window size, displaying less info if there is
      no room for it. It will also attempt to resolve ips to their host name in
      the background using reverse DNS on a best effort basis.
    '';
    homepage = "https://github.com/imsnif/what";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.unix;
  };
}
