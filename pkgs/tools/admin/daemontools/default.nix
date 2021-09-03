{ fetchurl, bash, glibc, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "daemontools";
  version = "0.76";

  src = fetchurl {
    url = "https://cr.yp.to/daemontools/daemontools-${version}.tar.gz";
    sha256 = "07scvw88faxkscxi91031pjkpccql6wspk4yrlnsbrrb5c0kamd5";
  };

  patches = [ ./fix-nix-usernamespace-build.patch ];

  configurePhase = ''
    cd daemontools-${version}

    sed -ie '1 s_$_ -include ${glibc.dev}/include/errno.h_' src/conf-cc

    substituteInPlace src/Makefile \
      --replace '/bin/sh' '${bash}/bin/bash -oxtrace'

    sed -ie "s_^PATH=.*_PATH=$src/daemontools-${version}/compile:''${PATH}_" src/rts.tests

    cat ${glibc.dev}/include/errno.h
  '';

  buildPhase = ''
    package/compile
  '';

  installPhase = ''
    for cmd in $(cat package/commands); do
      install -Dm755 "command/$cmd" "$out/bin/$cmd"
    done
  '';

  meta = {
    license = lib.licenses.publicDomain;
    homepage = "https://cr.yp.to/daemontools.html";
    description = "A collection of tools for managing UNIX services";

    maintainers = with lib.maintainers; [ kevincox ];
    platforms = lib.platforms.unix;
  };
}
