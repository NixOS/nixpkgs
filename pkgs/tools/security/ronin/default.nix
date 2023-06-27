{ pkgs, lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "ronin";
  gemdir = ./.;
  exes = [
    "ronin"
    "ronin-db"
    "ronin-exploits"
    "ronin-fuzzer"
    "ronin-payloads"
    "ronin-repos"
    "ronin-vulns"
    "ronin-web"
  ];

  passthru.updateScript = bundlerUpdateScript "ronin";

  meta = with lib; {
    description = "A free and Open Source Ruby toolkit for security research and development";
    homepage    = "https://ronin-rb.dev";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ Ch1keen ];
  };
}
