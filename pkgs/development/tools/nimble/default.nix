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

  buildInputs = [ nim ];

  patchPhase = ''
    substituteInPlace src/nimble.nim.cfg --replace "./vendor/nim" "${nim}/share"
  '';

  buildPhase = ''
    nim c src/nimble
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp src/nimble $out/bin
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath [stdenv.cc.libc openssl]}" \
        --add-needed libcrypto.so \
        "$out/bin/nimble"
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
