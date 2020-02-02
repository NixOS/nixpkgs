{ stdenv, fetchFromGitHub, makeWrapper, ruby }:

stdenv.mkDerivation rec {
  pname = "h";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "h";
    rev = "v${version}";
    hash = "sha256-chGrMtvLyyNtlM7PO1olVdkzkvMOk6OibHw+mqwVxIM=";
  };

  buildInputs = [ ruby ];

  installPhase = ''
    mkdir -p $out/bin
    cp h $out/bin/h
    cp up $out/bin/up
  '';

  meta = with stdenv.lib; {
    description = "faster shell navigation of projects";
    homepage = "https://github.com/zimbatm/h";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
  };
}
