{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "dnglab";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dnglab";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4uTpCBzBBkcpVBVZMOBD6f9ut71OuUNQ5+AkaQcU86M=";
  };

  cargoSha256 = "sha256-WvXQNDYvR6s4M2Hlpqwq1/wFQYW2QU/ngQimKOFkhOQ=";

  postInstall = ''
    rm $out/bin/benchmark $out/bin/identify
  '';

  meta = with lib; {
    description = "Camera RAW to DNG file format converter";
    homepage = "https://github.com/dnglab/dnglab";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dit7ya ];
  };
}
