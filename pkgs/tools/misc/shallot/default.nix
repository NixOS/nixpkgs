{ 
  stdenv, fetchFromGitHub,
  openssl
}:

let 
  version = "0.0.3";
in stdenv.mkDerivation {
  name = "shallot-${version}";

  src = fetchFromGitHub {
    owner = "katmagic";
    repo = "Shallot";
    rev = "shallot-${version}";
    sha256 = "0cjafdxvjkwb9vyifhh11mw0la7yfqswqwqmrfp1fy9jl7m0il9k";
  };

  buildInputs = [ openssl ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./shallot $out/bin/
  '';

  meta = {
    description = "Shallot allows you to create customized .onion addresses for your hidden service";

    license = stdenv.lib.licenses.mit;
    homepage = https://github.com/katmagic/Shallot;
    platforms = stdenv.lib.platforms.linux;
  };
}
