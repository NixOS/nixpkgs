{ fetchurl, bash, glibc, stdenv }:

stdenv.mkDerivation rec {
  name = "daemontools-0.76";

  src = fetchurl {
    url = "https://cr.yp.to/daemontools/${name}.tar.gz";
    sha256 = "07scvw88faxkscxi91031pjkpccql6wspk4yrlnsbrrb5c0kamd5";
  };

  patches = [ ./fix-nix-usernamespace-build.patch ];

  configurePhase = ''
    cd ${name}

    sed -ie '1 s_$_ -include ${glibc.dev}/include/errno.h_' src/conf-cc

    substituteInPlace src/Makefile \
      --replace '/bin/sh' '${bash}/bin/bash -oxtrace'

    sed -ie "s_^PATH=.*_PATH=$src/${name}/compile:''${PATH}_" src/rts.tests

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
    license = stdenv.lib.licenses.publicDomain;
    homepage = https://cr.yp.to/daemontools.html;
    description = "A collection of tools for managing UNIX services.";

    maintainers = with stdenv.lib.maintainers; [ kevincox ];
    platforms = stdenv.lib.platforms.unix;
  };
}
