{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "v${version}";
    sha256 = "05fqfwz34n4ijw7ydw2n6bh4bv64rhks85cn720sy5r7bmhfmfa8";
  };

  cargoSha256 = "161lz96a52s53rhhkxxhcg41bsmh8w6rv6nl8gwqmg3biszy7hah";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl curl ]
    ++ lib.optional stdenv.isDarwin Security;

  doCheck = !stdenv.isDarwin;

  postInstall = ''
    mkdir -p $out/etc/profile.d
    cp ./command-not-found.sh $out/etc/profile.d/command-not-found.sh
    substituteInPlace $out/etc/profile.d/command-not-found.sh \
      --replace "@out@" "$out"
  '';

  meta = with lib; {
    description = "A files database for nixpkgs";
    homepage = "https://github.com/bennofs/nix-index";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ bennofs ncfavier ];
  };
}
