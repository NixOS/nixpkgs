{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "imap-mailstat-exporter";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "bt909";
    repo = "imap-mailstat-exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-aR/94C9SI+FPs3zg3bpexmgGYrhxghyHwpXj25x0yuw=";
  };

  vendorSha256 = "sha256-M5Ho4CiO5DC6mWzenXEo2pu0WLHj5S8AV3oEFwD31Sw=";

  nativeBuildInputs = [ installShellFiles ];

  meta = with lib; {
    description = "Export Prometheus-style metrics about how many emails you have in your INBOX and in additional configured folders";
    homepage = "https://github.com/bt909/imap-mailstat-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ raboof ];
    platforms = platforms.linux;
  };
}
