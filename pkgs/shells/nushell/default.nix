{ stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, python3
, xorg
, libiconv
, AppKit
, Security
, withAllFeatures ? true
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "0fdi5c9l8ij2vqcxwi9203mh1qj3lcqsl4kl2rkshqj45hn4ab2a";
  };

  cargoSha256 = "11cr88jmy34lzjka7agzfvm13hvg66ksa735rzcdx7lcxha538f3";

  nativeBuildInputs = [ pkg-config ]
    ++ stdenv.lib.optionals (withAllFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ]
    ++ stdenv.lib.optionals (withAllFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ stdenv.lib.optionals (withAllFeatures && stdenv.isDarwin) [ AppKit ];

  cargoBuildFlags = stdenv.lib.optional withAllFeatures "--all-features";

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 marsam ];
  };

  passthru = {
    shellPath = "/bin/nu";
  };
}
