{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

with rustPlatform;

buildRustPackage rec {
  name = "rustfmt-${version}";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "rust-lang-nursery";
    repo = "rustfmt";
    rev = "d022f05f340b9aa4956ca315f5e424a6d3ab3248";
    sha256 = "1w6ll3802061wbggqhk31pmzws423qm7jc4hyxk8a6pf9ksp0nk5";
  };

  depsSha256 = "13rrhgzxxx5gwpwvyxw03m5xng9c1xyaycmqpi123ma3ps5822jf";

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/nrc/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
