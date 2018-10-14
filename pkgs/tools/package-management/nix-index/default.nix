{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, openssl, curl
, Security
}:

rustPlatform.buildRustPackage rec {
  name = "nix-index-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "bennofs";
    repo = "nix-index";
    rev = "v${version}";
    sha256 = "05fqfwz34n4ijw7ydw2n6bh4bv64rhks85cn720sy5r7bmhfmfa8";
  };
  cargoSha256 = "045qm7cyg3sdvf22i8b9cz8gsvggs5bn9xz8k1pvn5gxb7zj24cx";
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ openssl curl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  postInstall = ''
    mkdir -p $out/etc/profile.d
    cp ./command-not-found.sh $out/etc/profile.d/command-not-found.sh
    substituteInPlace $out/etc/profile.d/command-not-found.sh \
      --replace "@out@" "$out"
  '';

  meta = with stdenv.lib; {
    description = "A files database for nixpkgs";
    homepage = https://github.com/bennofs/nix-index;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.bennofs ];
    platforms = platforms.all;
  };
}
