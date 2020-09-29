{ stdenv, fetchFromGitHub, rustPlatform, Security, fetchpatch }:

rustPlatform.buildRustPackage rec {
  pname = "bandwhich";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "imsnif";
    repo = pname;
    rev = version;
    sha256 = "0963yfbf88hb5fvyckhs1vfvib5skkj9n17qibpv5vsdlynbaa96";
  };

  cargoSha256 = "0xp45kb0z7wiq6vnws4q7khbzslywh24sb43ssr39l1rajf7w64r";

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
