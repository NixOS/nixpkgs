{ lib, fetchFromGitHub, python3Packages }:

let
  rev = "4467bd46a7a798f738247a7f090c1505176bd597";
  sha256 = "0yf3pc3fws4nnh4nd8d3jpglmsyi69d17qqgpcnkpqca5l4cd25w";
in

python3Packages.buildPythonApplication rec {
  pname = "rpl";
  version = builtins.substring 0 7 rev;

  # Tests not included in pip package.
  doCheck = false;


  src = fetchFromGitHub {
    owner  = "rrthomas";
    repo   = "rpl";
    inherit rev sha256;
  };

  patches = [
    ./remove-argparse-manpage.diff # quickfix for ImportError: No module named build_manpages.build_manpages
  ];

  buildInputs = [
    #python3Packages.argparse-manpage # TODO
    python3Packages.chardet
  ];

  installPhase = ''
    mkdir -p $out/bin
    mv rpl $out/bin
  '';

  meta = with lib; {
    description = "Replace strings in files";
    homepage    = "https://github.com/rrthomas/rpl";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ teto ];
  };
}
