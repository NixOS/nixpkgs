{ lib
<<<<<<< HEAD
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildGoModule
, fetchFromGitHub
, fuse
, makeWrapper
, openssl
, pandoc
, pkg-config
, libfido2
}:

buildGoModule rec {
  pname = "gocryptfs";
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.3.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-lStaMj2f8lQZx2E42o4ikPmFQzydlN3PFKwFvUx37SI=";
  };

  vendorHash = "sha256-ir7FR7ndbPhzUOCVPrYO0SEe03wDFIP74I4X6HJxtE8=";
=======
    sha256 = "sha256-1+g8n6n2i7UKr4C5ZLNF5ceqdu3EYx4R6rQALVoGwTs=";
  };

  vendorHash = "sha256-7eAyuyqAvFQjkvsrkJEvop0veX7sGGX6xXAdUNuOXWU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    makeWrapper
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

  # use --suffix here to ensure we don't shadow /run/wrappers/bin/fusermount,
  # as the setuid wrapper is required to use gocryptfs as non-root on NixOS
  postInstall = ''
    wrapProgram $out/bin/gocryptfs \
      --suffix PATH : ${lib.makeBinPath [ fuse ]}
    ln -s $out/bin/gocryptfs $out/bin/mount.fuse.gocryptfs
  '';

  meta = with lib; {
    description = "Encrypted overlay filesystem written in Go";
    license = licenses.mit;
    homepage = "https://nuetzlich.net/gocryptfs/";
    maintainers = with maintainers; [ flokli offline prusnak ];
    platforms = platforms.unix;
  };
}
