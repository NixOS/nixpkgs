{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "racer-${version}";
  version = "1.2.10";
  src = fetchFromGitHub {
    owner = "phildawes";
    repo = "racer";
    rev = "e5ffe9efc1d10d4a7d66944b4c0939b7c575530e";
    sha256 = "1cvgd6gcwb82p387h4wl8wz07z64is8jrihmf2z84vxmlrasmprm";
  };

  depsSha256 = "1d44q7hfxijn40q7y6xawgd3c91i90fmd1dyx7i2v9as29js5694";

  buildInputs = [ makeWrapper ];

  preCheck = ''
    export RUST_SRC_PATH="${rustPlatform.rust.rustc.src}/src"
  '';

  doCheck = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -p target/release/racer $out/bin/
    wrapProgram $out/bin/racer --set RUST_SRC_PATH "${rustPlatform.rust.rustc.src}/src"
  '';

  meta = with stdenv.lib; {
    description = "A utility intended to provide Rust code completion for editors and IDEs";
    homepage = https://github.com/phildawes/racer;
    license = stdenv.lib.licenses.mit;
    maintainers = with maintainers; [ jagajaga globin ];
    platforms = platforms.all;
  };
}
