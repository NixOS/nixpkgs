{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go365";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "optiv";
    repo = "Go365";
    rev = version;
    sha256 = "0dh89hf00fr62gjdw2lb1ncdxd26nvlsh2s0i6981bp8xfg2pk5r";
  };

  vendorSha256 = "0fx2966xfzmi8yszw1cq6ind3i2dvacdwfs029v3bq0n8bvbm3r2";

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    mv $out/bin/Go365 $out/bin/$pname
  '';

  meta = with lib; {
    description = "Office 365 enumeration tool";
    homepage = "https://github.com/optiv/Go365";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "Go365";
  };
}
