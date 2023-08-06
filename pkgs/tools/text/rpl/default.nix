{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "rpl";
  version = "1.10";

  # Tests not included in pip package.
  doCheck = false;


  src = fetchFromGitHub {
    owner = "rrthomas";
    repo = "rpl";
    rev = "4467bd46a7a798f738247a7f090c1505176bd597";
    sha256 = "0yf3pc3fws4nnh4nd8d3jpglmsyi69d17qqgpcnkpqca5l4cd25w";
  };

  patches = [
    ./remove-argparse-manpage.diff # quickfix for ImportError: No module named build_manpages.build_manpages
  ];

  propagatedBuildInputs = [
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
