{ stdenv
, fetchFromGitHub
, ruby
}:

# No gems used, so mkDerivation is fine.
stdenv.mkDerivation rec {
  pname = "nix-universal-prefetch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "samueldr";
    repo = "nix-universal-prefetch";
    rev = "v${version}";
    sha256 = "1id9iaibrm2d3fa9dkcxnb3sd0j1vh502181gdd199a1cfsmzh1i";
  };

  installPhase = ''
    mkdir -pv $out/bin
    cp nix-universal-prefetch $out/bin/nix-universal-prefetch
    substituteInPlace "$out/bin/nix-universal-prefetch" \
      --replace "/usr/bin/env nix-shell" "${ruby}/bin/ruby"
  '';

  meta = with stdenv.lib; {
    description = "Uses nixpkgs fetchers to figure out hashes";
    homepage = https://github.com/samueldr/nix-universal-prefetch;
    license = licenses.mit;
    maintainers = with maintainers; [ samueldr ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
