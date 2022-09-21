{ lib, stdenv, fetchFromGitHub, apacheHttpd, python, ncurses, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "mod_wsgi";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "mod_wsgi";
    rev = version;
    hash = "sha256-gaWA6m4ENYtm88hCaoqrcIooA0TBI7Kj6fU6pPShoo4=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2022-2255.patch";
      url = "https://github.com/GrahamDumpleton/mod_wsgi/commit/af3c0c2736bc0b0b01fa0f0aad3c904b7fa9c751.patch";
      sha256 = "sha256-5gW0E/Ojm/T6aZLuw6BdYwfWN4wHAD7/zz1qjs8DbE4=";
    })
  ];

  buildInputs = [ apacheHttpd python ncurses ];

  postPatch = ''
    sed -r -i -e "s|^LIBEXECDIR=.*$|LIBEXECDIR=$out/modules|" \
      ${if stdenv.isDarwin then "-e 's|/usr/bin/lipo|lipo|'" else ""} \
      configure
  '';

  meta = {
    homepage = "https://github.com/GrahamDumpleton/mod_wsgi";
    description = "Host Python applications in Apache through the WSGI interface";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
