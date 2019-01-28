{ stdenv, fetchFromGitHub, rustPlatform, cmake, perl, pkgconfig, zlib
, darwin, libiconv
}:

with rustPlatform;

buildRustPackage rec {
  name = "sd-${version}";
  version = "0.4.3";

  cargoSha256 = "08zzn3a32xfjkmpawcjppn1mr26ws3iv40cckiz8ldz4qc8y9gdh";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = "sd";
    rev = "v${version}";
    sha256 = "0jy11a3xfnfnmyw1kjmv4ffavhijs8c940kw24vafklnacx5n88m";
  };

  nativeBuildInputs = [ cmake pkgconfig perl ];
  buildInputs = [ zlib ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv darwin.apple_sdk.frameworks.Security ]
  ;

  postInstall = ''
    mkdir -p $out/share/man/man1
    cp contrib/man/exa.1 $out/share/man/man1/

    mkdir -p $out/share/bash-completion/completions
    cp contrib/completions.bash $out/share/bash-completion/completions/exa

    mkdir -p $out/share/fish/vendor_completions.d
    cp contrib/completions.fish $out/share/fish/vendor_completions.d/exa.fish

    mkdir -p $out/share/zsh/site-functions
    cp contrib/completions.zsh $out/share/zsh/site-functions/_exa
  '';

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Intuitive find & replace CLI (sed alternative) ";
    longDescription = ''
      sd uses regex syntax that you already know from JavaScript and Python. Forget about dealing with quirks of sed or awk - get productive immediately.
    '';
    homepage = https://github.com/chmln/sd;
    license = licenses.mit;
    maintainers = [ maintainers.abhi18av ];
  };
}
