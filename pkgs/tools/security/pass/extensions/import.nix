{ stdenv, pass, fetchFromGitHub, pythonPackages, makeWrapper, fetchpatch }:

let
  pythonEnv = pythonPackages.python.withPackages (p: [
    p.defusedxml
    p.setuptools
    p.pyaml
  ]);

in stdenv.mkDerivation rec {
  pname = "pass-import";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-import";
    rev = "v${version}";
    sha256 = "1q8rln4djh2z8j2ycm654df5y6anm5iv2r19spgy07c3fnisxlac";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ pythonEnv ];

  patches = [
    # https://github.com/roddhjav/pass-import/pull/91
    (fetchpatch {
      url = "https://github.com/roddhjav/pass-import/commit/6ccaf639e92df45bd400503757ae4aa2c5c030d7.patch";
      sha256 = "0lw9vqvbqcy96s7v7nz0i1bdx93x7qr13azymqypcdhjwmq9i63h";
    })
  ];

  postPatch = ''
    sed -i -e 's|$0|${pass}/bin/pass|' import.bash
  '';

  dontBuild = true;

  installFlags = [
    "PREFIX=$(out)"
    "BASHCOMPDIR=$(out)/etc/bash_completion.d"
  ];

  postFixup = ''
    install -D pass_import.py $out/${pythonPackages.python.sitePackages}/pass_import.py
    wrapProgram $out/lib/password-store/extensions/import.bash \
      --prefix PATH : "${pythonEnv}/bin" \
      --prefix PYTHONPATH : "$out/${pythonPackages.python.sitePackages}" \
      --run "export PREFIX"
  '';

  meta = with stdenv.lib; {
    description = "Pass extension for importing data from existing password managers";
    homepage = https://github.com/roddhjav/pass-import;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 the-kenny fpletz tadfisher ];
    platforms = platforms.unix;
  };
}
