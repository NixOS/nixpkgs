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

  cargoSha256 = "0q9cd7wgyapl70hcgl4zrhprq1k1cd8z247vddkzv6g9k415v691";

  buildInputs = lib.optional stdenv.isDarwin Security;

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
    maintainers = with maintainers; [ Br1ght0ne ma27 ];
    platforms = platforms.unix;
  };
}
