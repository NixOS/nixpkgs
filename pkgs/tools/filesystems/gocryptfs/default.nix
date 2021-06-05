{ lib
, buildGoModule
, fetchFromGitHub
, openssl
, pandoc
, pkg-config
}:

buildGoModule rec {
  pname = "gocryptfs";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YEoniHWEhjCRMhktHEmeflSB5sTkxAm2OUtdh0P87fI=";
  };

  runVend = true;
  vendorSha256 = "sha256-1a/PqHSXptwxwcgOtmDNsv1kADT6Uf1lwQYaQU/NIBg=";

  nativeBuildInputs = [ pandoc pkg-config ];
  buildInputs = [ openssl ];

  buildFlagsArray = ''
    -ldflags=
      -X main.GitVersion=${version}
      -X main.GitVersionFuse=[vendored]
      -X main.BuildDate=unknown
  '';

  subPackages = [ "." "gocryptfs-xray" "contrib/statfs" ];

  postBuild = ''
    pushd Documentation/
    mkdir -p $out/share/man/man1
    pandoc MANPAGE.md -s -t man -o $out/share/man/man1/gocryptfs.1
    pandoc MANPAGE-XRAY.md -s -t man -o $out/share/man/man1/gocryptfs-xray.1
    pandoc MANPAGE-STATFS.md -s -t man -o $out/share/man/man1/statfs.1
    popd
  '';

  meta = with lib; {
    description = "Encrypted overlay filesystem written in Go";
    license = licenses.mit;
    homepage = "https://nuetzlich.net/gocryptfs/";
    maintainers = with maintainers; [ flokli offline prusnak ];
    platforms = platforms.unix;
  };
}
