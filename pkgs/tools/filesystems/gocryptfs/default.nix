{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, openssl
, pandoc
, pkg-config
, libfido2
}:

let
  # pandoc is currently broken on aarch64-darwin
  # because of missing ghc
  brokenPandoc = stdenv.isDarwin && stdenv.isAarch64;
in

buildGoModule rec {
  pname = "gocryptfs";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wiagmym8mwi0vpvrs5ryn3zjwha8ilh7xkavvkd1gqd5laln0kp";
  };

  vendorSha256 = "10az8n7z4rhsk1af2x6v3pmxg4zp7c9cal35ily8bdzzcb9cpgs0";

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals (!brokenPandoc) [
    pandoc
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [ libfido2 ];

  buildFlagsArray = ''
    -ldflags=
      -X main.GitVersion=${version}
      -X main.GitVersionFuse=[vendored]
      -X main.BuildDate=unknown
  '';

  subPackages = [ "." "gocryptfs-xray" "contrib/statfs" ];

  postBuild = lib.optionalString (!brokenPandoc) ''
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
