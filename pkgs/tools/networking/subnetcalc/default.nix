{ lib, stdenv, fetchFromGitHub, cmake, ninja }:

stdenv.mkDerivation rec {
  pname = "subnetcalc";
  version = "2.4.22";

  src = fetchFromGitHub {
    owner = "dreibh";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "sha256-5sDEMS4RgHdGQZAT2MVF/Ls0KXwdKzX+05uQpHhCZn8=";
  };

  nativeBuildInputs = [ cmake ninja ];

  meta = with lib; {
    description = "SubNetCalc is an IPv4/IPv6 subnet address calculator";
    longDescription = ''
      SubNetCalc is an IPv4/IPv6 subnet address calculator. For given IPv4 or
      IPv6 address and netmask or prefix length, it calculates network address,
      broadcast address, maximum number of hosts and host address range. Also,
      it prints the addresses in binary format for better understandability.
      Furthermore, it prints useful information on specific address types (e.g.
      type, scope, interface ID, etc.).
    '';
    homepage = "https://www.uni-due.de/~be0001/subnetcalc/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ atila ];
    platforms = platforms.unix;
  };
}
