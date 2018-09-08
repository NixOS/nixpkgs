{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "symlinks-${version}";
  version = "1.4.3";

  src = fetchurl {
    url = "https://github.com/brandt/symlinks/archive/v${version}.tar.gz";
    sha256 = "1cihrd3dap52z1msdhhgda7b7wy1l5ysfvyba8yxb3zjk0l5n417";
  };

  buildFlags = [ "CC=${stdenv.cc}/bin/cc" ];

  installPhase = ''
    mkdir -p $out/bin $out/share/man/man8
    cp symlinks $out/bin
    cp symlinks.8 $out/share/man/man8
  '';

  meta = with stdenv.lib; {
    description = "Find and remedy problematic symbolic links on a system";
    homepage = https://github.com/brandt/symlinks;
    license = licenses.mit;
    maintainers = with maintainers; [ goibhniu ckauhaus ];
    platforms = platforms.unix;
  };
}
