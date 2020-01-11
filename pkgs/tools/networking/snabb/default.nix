{ stdenv, fetchFromGitHub, bash, makeWrapper, git, mysql, diffutils, which, coreutils, procps, nettools
,supportOpenstack ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "snabb";
  version = "2018.01.2";

  src = fetchFromGitHub {
    owner = "snabbco";
    repo = "snabb";
    rev = "v${version}";
    sha256 = "0n6bjf5g4imy0aql8fa55c0db3w8h944ia1dk10167x5pqvkgdgm";
  };

  buildInputs = [ makeWrapper ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=stringop-truncation" ];

  patchPhase = ''
    patchShebangs .

    # some hardcodeism
    for f in $(find src/program/snabbnfv/ -type f); do
      substituteInPlace $f --replace "/bin/bash" "${bash}/bin/bash"
    done
  '' + optionalString supportOpenstack ''
    # We need a way to pass $PATH to the scripts
    sed -i '2iexport PATH=${git}/bin:${mysql}/bin:${which}/bin:${procps}/bin:${coreutils}/bin' src/program/snabbnfv/neutron_sync_master/neutron_sync_master.sh.inc
    sed -i '2iexport PATH=${git}/bin:${coreutils}/bin:${diffutils}/bin:${nettools}/bin' src/program/snabbnfv/neutron_sync_agent/neutron_sync_agent.sh.inc
  '';

  preBuild = ''
    make clean
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp src/snabb $out/bin
  '';

  # Dependencies are underspecified: "make -C src obj/arch/sse2_c.o" fails with
  # "Fatal error: can't create obj/arch/sse2_c.o: No such file or directory".
  enableParallelBuilding = false;

  meta =  {
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
    maintainers = [ maintainers.lukego maintainers.domenkozar ];
  };
}
