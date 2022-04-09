{ stdenv, lib, cosmopolitan }:

stdenv.mkDerivation {
  pname = "cosmoc";
  inherit (cosmopolitan) version;

  doInstallCheck = true;
  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cat <<EOF >$out/bin/cosmoc
    #!${stdenv.shell}
    exec ${stdenv.cc}/bin/${stdenv.cc.targetPrefix}gcc \
      -O -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone \
      "\$@" \
      -Wl,--gc-sections -Wl,-z,max-page-size=0x1000 \
      -fuse-ld=bfd -Wl,-T,${cosmopolitan}/lib/ape.lds \
      -include ${cosmopolitan}/include/cosmopolitan.h \
      ${cosmopolitan}/lib/{crt.o,ape.o,cosmopolitan.a}
    EOF
    chmod +x $out/bin/cosmoc
    runHook postInstall
  '';

  installCheckPhase = ''
    printf 'main() { printf("hello world\\n"); }\n' >hello.c
    $out/bin/cosmoc hello.c
    ./a.out
  '';

  meta = with lib; {
    homepage = "https://justine.lol/cosmopolitan/";
    description = "compiler for Cosmopolitan C programs";
    license = licenses.mit;
    maintainers = teams.cosmopolitan.members;
  };
}
