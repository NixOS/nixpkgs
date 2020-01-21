{ stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = version;
    sha256 = "0xq2lv06dx7g00b4amk131krlsb6acsz7b228pn3iz6gy31fhz3y";
  };

  cargoSha256 = "1sa81570cvvpqgdcpnb08b0q4c6ap8a2wxfp2z336jzbv0zgv8a6";

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
