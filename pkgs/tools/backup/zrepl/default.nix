{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
, openssh
}:
buildGoModule rec {
  pname = "zrepl";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zrepl";
    repo = "zrepl";
    rev = "v${version}";
    sha256 = "5Bp8XGCjibDJgeAjW98rcABuddI+CV4Fh3hFJaKKwbo=";
  };

  vendorSha256 = "MwmYiK2z7ZK5kKBZV7K6kCZRSd7v5Sgjoih1eeOh6go=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    substitute dist/systemd/zrepl.service $out/lib/systemd/system/zrepl.service \
      --replace /usr/local/bin/zrepl $out/bin/zrepl

    wrapProgram $out/bin/zrepl \
      --prefix PATH : ${lib.makeBinPath [ openssh ]}
  '';

  meta = with lib; {
    homepage = "https://zrepl.github.io/";
    description = "A one-stop, integrated solution for ZFS replication";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ cole-h danderson ];
  };
}
