{ stdenv, fetchurl, clang, curl, libzip }:

let version = "1.1.0"; in
stdenv.mkDerivation {
  name = "tldr-${version}";

  src = fetchurl {
    url = "https://github.com/tldr-pages/tldr-cpp-client/archive/v${version}.tar.gz";
    sha256 = "0f2ijx17hv64w6zrv0vhj1j1jikzsj42657510vxcqqr8zanzlpf";
  };

  buildInputs = [ curl clang libzip ];

  preBuild = ''
    cd src
  '';

  installPhase = ''
    install -d $prefix/bin
    install tldr $prefix/bin
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Simplified and community-driven man pages";
    longDescription = ''
      tldr pages gives common use cases for commands, so you don't need to hunt
      through a man page for the correct flags.
    '';
    homepage = http://tldr-pages.github.io;
    license = licenses.mit;
    maintainers = with maintainers; [ taeer nckx ];
    platforms = platforms.linux;
  };
}
