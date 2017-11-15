{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  name = "racer-${version}";
  version = "2.0.12";

  src = fetchFromGitHub {
    owner = "racer-rust";
    repo = "racer";
    rev = version;
    sha256 = "0y1xlpjr8y8gsmmrjlykx4vwzf8akk42g35kg3kc419ry4fli945";
  };

  cargoSha256 = "1h3jv4hajdv6k309kjr6b6298kxmd0faw081i3788sl794k9mp0j";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustPlatform.rustcSrc}"
  '';

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustPlatform.rustcSrc}"
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/racer-rust/racer;
    license = licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
    platforms = platforms.all;
  };
}
