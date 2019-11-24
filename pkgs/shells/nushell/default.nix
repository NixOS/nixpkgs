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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "0_5_0";
    sha256 = "1s60w29c8sv0a4nmpggls9pkqyfrwwxjzd65p68d1xxxsdb36rzj";
  };

  cargoSha256 = "0b8alc3si6y4xmn812izknbkfkz64kz7kcnq4xaqws6iqn7pqidp";

  nativeBuildInputs = [ pkg-config ]
    ++ stdenv.lib.optionals (withAllFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = stdenv.lib.optionals stdenv.isLinux [ openssl ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ]
    ++ stdenv.lib.optionals (withAllFeatures && stdenv.isLinux) [ xorg.libX11 ]
    ++ stdenv.lib.optionals (withAllFeatures && stdenv.isDarwin) [ AppKit ];

  cargoBuildFlags = stdenv.lib.optionals withAllFeatures [ "--features" "all" ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with stdenv.lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };

  passthru = {
    shellPath = "/bin/nu";
  };
}
