{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "00xxk1ipr3hndd717q52j7s2wfxis1p4glaa9lvp72gwwzmv5k9w";
  };

  postPatch = ''
    substituteInPlace src/main.rs --replace /usr/share $out/share
  '';

  cargoSha256 = "1l34i7qalid9mlcbpqhbb2bxgn2ylb2lwki4c0hf4kkq646ql0n1";

  postInstall = ''
    mkdir -p $out/share/${pname}
    cp -rv config/* themes $out/share/${pname}
  '';

  meta = with stdenv.lib; {
    description = "A generator for LS_COLORS with support for multiple color themes";
    homepage = "https://github.com/sharkdp/vivid";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.unix;
  };
}
