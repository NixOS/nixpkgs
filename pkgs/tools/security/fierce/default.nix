{ stdenv, fetchurl, makeWrapper, perl, perlPackages }:

stdenv.mkDerivation rec {
  name = "fierce-${version}";
  version = "0.9.9-1kali4";

  src = fetchurl {
    url = "http://git.kali.org/gitweb/?p=packages/fierce.git;a=snapshot;h=3bb8050c1e1ebdb1090e103a494c8b1fc0928509;sf=tgz";
    name = "${name}.tar.gz";
    sha256 = "0ikiqlajivxybvbgmhsl767m5j1hqaggxic3yfzp8vk1d3mpbhy7";
  };

  buildInputs = [ perl ];
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace fierce.pl --replace hosts.txt "$out/share/hosts.txt"
  '';

  installPhase = ''
    install -vD fierce.pl $out/bin/fierce
    install -vD hosts.txt -t $out/share
    wrapProgram "$out/bin/fierce" --set PERL5LIB \
      "${with perlPackages; stdenv.lib.makePerlPath [ NetDNS ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/mschwager/fierce;
    description = "DNS reconnaissance tool for locating non-contiguous IP space";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.globin ];
    platforms = platforms.all;
  };
}
