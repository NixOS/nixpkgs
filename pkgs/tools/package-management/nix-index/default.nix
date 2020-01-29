{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig, makeWrapper, openssl, curl
, nix, Security
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
  cargoSha256 = "06idjb5h5fahqklyxnss2zffrvvfbcw0hjh1mcrf1872s4x78ags";
  nativeBuildInputs = [ pkgconfig makeWrapper ];
  buildInputs = [ openssl curl ]
    ++ stdenv.lib.optional stdenv.isDarwin Security;

  doCheck = !stdenv.isDarwin;

  postInstall = ''
    mkdir -p $out/etc/profile.d
    cp ./command-not-found.sh $out/etc/profile.d/command-not-found.sh
    substituteInPlace $out/etc/profile.d/command-not-found.sh \
      --replace "@out@" "$out"
    wrapProgram $out/bin/nix-index \
      --prefix PATH : "${stdenv.lib.makeBinPath [ nix ]}"
  '';

  meta = with stdenv.lib; {
    description = "A files database for nixpkgs";
    homepage = https://github.com/bennofs/nix-index;
    license = with licenses; [ bsd3 ];
    maintainers = [ maintainers.bennofs ];
    platforms = platforms.all;
  };
}
