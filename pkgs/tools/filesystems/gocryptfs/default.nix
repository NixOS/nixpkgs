{ stdenv
, buildGoModule
, fetchFromGitHub
, openssl
, pandoc
, pkg-config
}:

buildGoModule rec {
  pname = "gocryptfs";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
    sha256 = "1acalwrr5xqhpqca3gypj0s68w6vpckxmg5z5gfgh8wx6nqx4aw9";
  };

  runVend = true;
  vendorSha256 = "0z3y51sgr1rmr23jpc5h5d5lw14p3qzv48rc7zj7qa4rd5cfhsgi";

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

  meta = with stdenv.lib; {
    description = "Encrypted overlay filesystem written in Go";
    license = licenses.mit;
    homepage = "https://nuetzlich.net/gocryptfs/";
    maintainers = with maintainers; [ flokli offline prusnak ];
    platforms = platforms.unix;
  };
}
