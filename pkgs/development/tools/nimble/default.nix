{ stdenv, fetchFromGitHub, nim, openssl }:

stdenv.mkDerivation rec {
  name = "nimble-${version}";

  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "nimble";
    rev = "v${version}";
    sha256 = "12znxzj1j5fflw2mkkrns9n7qg6sf207652zrdyf7h2jdyzzb73x";
  };

  buildInputs = [ nim openssl ];

  patchPhase = ''
    substituteInPlace src/nimble.nim.cfg --replace "./vendor/nim" "${nim}/share"
    echo "--clib:crypto" >> src/nimble.nim.cfg
  '';

  buildPhase = ''
    cd src && nim c -d:release nimble
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp nimble $out/bin
  '';

  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Package manager for the Nim programming language";
    homepage = https://github.com/nim-lang/nimble;
    license = licenses.bsd2;
    maintainers = with maintainers; [ kamilchm ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
