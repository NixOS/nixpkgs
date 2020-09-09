{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = version;
    sha256 = "0fhy3zys41bkpjmvhkxf413004hvv2kngcgf4819mw22w14zfvgr";
  };

  cargoSha256 = "015ff049xb699gig0cwr5i7n8hgw1316dkdpnqd4843h54x7bp5y";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
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
    maintainers = with maintainers; [ filalex77 ma27 ];
    platforms = platforms.unix;
  };
}
