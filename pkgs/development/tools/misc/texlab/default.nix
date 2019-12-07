{ stdenv
, rustPlatform
, fetchFromGitHub
, nodejs
, Security
, texlab-citeproc-build-deps
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b9lw6cmh7gyzj0pb3ghvqc3q7lzl12bfg9pjhl31lib3mmga8yb";
  };

  cargoSha256 = "0qnysl0ayc242dgvanqgmx8v4a2cjg0f1lhbyw16qjv61qcsx8y5";

  nativeBuildInputs = [ nodejs ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  preBuild = ''
    rm build.rs
    ln -s ${texlab-citeproc-build-deps}/lib/node_modules/citeproc/node_modules src/citeproc/js
    (cd src/citeproc/js && npm run dist)
  '';

  meta = with stdenv.lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = https://texlab.netlify.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar metadark ];
    platforms = platforms.all;
  };
}
