{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "vivid";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "13x0295v5blvv8dxhimbdjh81l7xl0vm6zni3qjd85psfn61371q";
  };

  postPatch = ''
    substituteInPlace src/main.rs --replace /usr/share $out/share
  '';

  cargoSha256 = "125392a7x0h9jgcqc4wcaky0494xmr82iacxwl883kf0g227rv2y";

  postInstall = ''
    mkdir -p $out/share/${pname}
    cp -rv config/* themes $out/share/${pname}
  '';

  meta = with stdenv.lib; {
    description = "A generator for LS_COLORS with support for multiple color themes";
    homepage = https://github.com/sharkdp/vivid;
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.dtzWill ];
    platforms = platforms.unix;
  };
}
