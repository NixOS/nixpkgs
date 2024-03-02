{ lib
, stdenv
, fetchFromGitHub
, meson
, pkg-config
, ninja
, rizin
, openssl
}:

stdenv.mkDerivation rec {
  pname = "jsdec";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "rizinorg";
    repo = "jsdec";
    rev = "v${version}";
    hash = "sha256-iVaxxPBIJRhZrmejAOL/Fb4k66mGsZOBs7UikgMj5WA=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  preConfigure = ''
    cd p
  '';
  mesonFlags = [ "-Djsc_folder=.." ];
  buildInputs = [ openssl rizin ];

  meta = with lib; {
    description = "Simple decompiler for Rizin";
    homepage = src.meta.homepage;
    license = with licenses; [ asl20 bsd3 mit ];
    maintainers = with maintainers; [ chayleaf ];
  };
}
