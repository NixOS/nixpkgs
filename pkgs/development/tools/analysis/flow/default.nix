{ stdenv, fetchFromGitHub, lib, ocaml, libelf, cf-private, CoreServices }:

with lib;

stdenv.mkDerivation rec {
  version = "0.22.1";
  name = "flow-${version}";
  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    sha256 = "11d04g8rvjv2q79pmrjjx8lmmm1ix8kih7wc0adln0ap5123ph46";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp bin/flow $out/bin/
  '';

  buildInputs = [ ocaml libelf ]
    ++ optionals stdenv.isDarwin [ cf-private CoreServices ];

  meta = with stdenv.lib; {
    description = "A static type checker for JavaScript";
    homepage = http://flowtype.org;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh globin ];
  };
}
