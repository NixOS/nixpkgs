{ lib, stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = version;
    sha256 = "014blvrv0kk4gzga86mbk7gd5dl1szajfi972da3lrfznck1w24n";
  };

  cargoSha256 = "119szaighki565w28la6qg25s3cv8wviqin9f7f9w8x2rif3ipb3";

  buildInputs = lib.optional stdenv.isDarwin Security;

  # 10 passed; 47 failed https://hydra.nixos.org/build/148943783/nixlog/1
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "A CLI utility for displaying current network utilization";
    longDescription = ''
      bandwhich sniffs a given network interface and records IP packet size, cross
      referencing it with the /proc filesystem on linux or lsof on MacOS. It is
      responsive to the terminal window size, displaying less info if there is
      no room for it. It will also attempt to resolve ips to their host name in
      the background using reverse DNS on a best effort basis.
    '';
    homepage = "https://github.com/imsnif/bandwhich";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ma27 SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
