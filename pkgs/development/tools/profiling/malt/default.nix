{ stdenv, lib
, fetchFromGitHub
, cmake, nodejs, libelf, libunwind
}:

stdenv.mkDerivation rec {
  pname = "malt";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "memtt";
    repo = "malt";
    rev = "v${version}";
    sha256 = "sha256-6GGIdBaw/JSc2Qexy+P1NON27EBBRltthyQpMPZwi+8=";
  };

  postPatch = ''
    sed -i s,@CMAKE_INSTALL_PREFIX@/@CMAKE_INSTALL_LIBDIR@,@CMAKE_INSTALL_LIBDIR@, \
      src/integration/malt.sh.in
    sed -i -e 's,^NODE=""$,NODE=${nodejs}/bin/node,' -e s,^detectNodeJS$,, \
      src/integration/malt-{webview,passwd}.sh.in
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libelf libunwind ];

  meta = with lib; {
    description = "Memory tool to find where you allocate your memory";
    homepage = "https://github.com/memtt/malt";
    license = licenses.cecill-c;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
