{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  name = "racer-${version}";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "phildawes";
    repo = "racer";
    rev = version;
    sha256 = "09wgfrb0z2d2icfk11f1jal5p93sqjv3jzmzcgw0pgw3zvffhni3";
  };

  depsSha256 = "0mnq7dk9wz2k9jhzciknybwc471sy8f71cd15m752b5ng6v1f5kn";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustPlatform.rust.rustc.src}/src"
  '';

  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustPlatform.rustcSrc}"
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/phildawes/racer;
    license = licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
    platforms = platforms.all;
  };
}
