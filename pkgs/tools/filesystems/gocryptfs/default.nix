{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, openssl
, pandoc
, pkg-config
, libfido2
}:

buildGoModule rec {
  pname = "gocryptfs";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nACBEOL/vnqxdAGI37k9bxgQKgpi35/tsuCxsQ9I2sw=";
  };

  vendorSha256 = "sha256-Q/oBT5xdLpgQCIk7KES6c8+BaCQVUIwCwVufl4oTFRs=";

  nativeBuildInputs = [
    pkg-config
    pandoc
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [ libfido2 ];

  ldflags = [
    "-X main.GitVersion=${version}"
    "-X main.GitVersionFuse=[vendored]"
    "-X main.BuildDate=unknown"
  ];

  subPackages = [ "." "gocryptfs-xray" "contrib/statfs" ];

  postBuild = ''
    pushd Documentation/
    mkdir -p $out/share/man/man1
    # taken from Documentation/MANPAGE-render.bash
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
