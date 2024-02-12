{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "subnetcalc";
  version = "2.4.23";

  src = fetchFromGitHub {
    owner = "dreibh";
    repo = "subnetcalc";
    rev = "subnetcalc-${finalAttrs.version}";
    hash = "sha256-uX/roOWjeuuuEFpBbF+hEPDOo0RTR79WpyNvr9U7wR4=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  meta = {
    description = "SubNetCalc is an IPv4/IPv6 subnet address calculator";
    homepage = "https://www.uni-due.de/~be0001/subnetcalc/";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      SubNetCalc is an IPv4/IPv6 subnet address calculator. For given IPv4 or
      IPv6 address and netmask or prefix length, it calculates network address,
      broadcast address, maximum number of hosts and host address range. Also,
      it prints the addresses in binary format for better understandability.
      Furthermore, it prints useful information on specific address types (e.g.
      type, scope, interface ID, etc.).
    '';
    mainProgram = "subnetcalc";
    maintainers = with lib.maintainers; [ atila ];
    platforms = lib.platforms.unix;
  };
})
