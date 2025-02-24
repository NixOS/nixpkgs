{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "acme-dns";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "joohoi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qQwvhouqzkChWeu65epgoeMNqZyAD18T+xqEMgdMbhA=";
  };

  vendorHash = "sha256-q/P+cH2OihvPxPj2XWeLsTBHzQQABp0zjnof+Ys/qKo=";

  postInstall = ''
    install -D -m0444 -t $out/lib/systemd/system ./acme-dns.service
    substituteInPlace $out/lib/systemd/system/acme-dns.service --replace "/usr/local/bin/acme-dns" "$out/bin/acme-dns"
  '';

  passthru.tests = { inherit (nixosTests) acme-dns; };

  meta = {
    description = "Limited DNS server to handle ACME DNS challenges easily and securely";
    homepage = "https://github.com/joohoi/acme-dns";
    changelog = "https://github.com/joohoi/acme-dns/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilylange ];
    mainProgram = "acme-dns";
  };
}
