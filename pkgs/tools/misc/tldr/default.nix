{stdenv, clang, fetchurl, curl}:

with stdenv.lib;

let version = "1.0"; in
stdenv.mkDerivation {
  name = "tldr-${version}";

  src = fetchurl {
    url = "https://github.com/tldr-pages/tldr-cpp-client/archive/v${version}.tar.gz";
    sha256 = "11k2pc4vfhx9q3cfd1145sdwhis9g0zhw4qnrv7s7mqnslzrrkgw";
  };

  meta = {
    inherit version;
    description = "Simplified and community-driven man pages";
    longDescription = ''
      tldr pages gives common use cases for commands, so you don't need to hunt through a man page for the correct flags.
    '';
    homepage = http://tldr-pages.github.io;
    license = licenses.mit;
    maintainers = [maintainers.taeer];
    platforms = platforms.linux;

  };

  buildInputs = [curl clang];

  preBuild = ''
    cd src
  '';

  installPhase = ''
    install -d $prefix/bin
    install tldr $prefix/bin
  '';
}
