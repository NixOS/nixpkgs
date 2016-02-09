{ stdenv, lib, fetchurl, bash, makeWrapper, git, mariadb, diffutils }:

stdenv.mkDerivation rec {
  name = "snabb-${version}";
  version = "2015.12";

  src = fetchurl {
    url = "https://github.com/SnabbCo/snabbswitch/archive/v${version}.tar.gz";
    sha256 = "1949a6d3hqdr2hdfmrr1na9gvjdwdahadbhmvz2pg7azmpq6ssmr";
  };

  buildInputs = [ makeWrapper ];

  patchPhase = ''
    patchShebangs .

    # some hardcodeism
    for f in $(find src/program/snabbnfv/ -type f); do
      substituteInPlace $f --replace "/bin/bash" "${bash}/bin/bash"
    done
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp src/snabb $out/bin

    wrapProgram $out/bin/snabb --prefix PATH : "${ lib.makeBinPath [ git mariadb diffutils ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/SnabbCo/snabbswitch;
    description = "Simple and fast packet networking toolkit";
    longDescription = ''
      Snabb Switch is a LuaJIT-based toolkit for writing high-speed
      packet networking code (such as routing, switching, firewalling,
      and so on). It includes both a scripting inteface for creating
      new applications and also some built-in applications that are
      ready to run.
      It is especially intended for ISPs and other network operators.
    '';
    platforms = [ "x86_64-linux" ];
    license = licenses.asl20;
    maintainers = [ maintainers.lukego maintainers.iElectric ];
  };
}

