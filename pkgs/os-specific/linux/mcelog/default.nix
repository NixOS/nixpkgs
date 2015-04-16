{ stdenv, fetchFromGitHub }:

let version = "114"; in
stdenv.mkDerivation {
  name = "mcelog-${version}";

  src = fetchFromGitHub {
    sha256 = "1blxz5ilrlh2030gxmfqlhcb53qh2bxp5nxyc97m1z8a52idjh0v";
    rev = "v${version}";
    repo = "mcelog";
    owner = "andikleen";
  };

  makeFlags = "prefix=$(out) etcprefix=$(out) DOCDIR=$(out)/share/doc";

  preInstall = ''
    mkdir -p $out/share/{doc,man/man{5,8}}
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Log machine checks (memory, IO, and CPU hardware errors)";
    homepage = http://mcelog.org/;
    license = with licenses; gpl2;
    maintainers = with maintainers; [ nckx ];
  };
}
