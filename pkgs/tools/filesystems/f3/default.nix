{
  stdenv,
  lib,
  fetchFromGitHub,
  parted,
  systemd,
  argp-standalone,
}:

stdenv.mkDerivation rec {
  pname = "f3";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "AltraMayor";
    repo = pname;
    rev = "v${version}";
    sha256 = "17l5vspfcgfbkqg7bakp3gql29yb05gzawm8n3im30ilzdr53678";
  };

  postPatch = ''
    sed -i 's/-oroot -groot//' Makefile

    for f in f3write.h2w log-f3wr; do
     substituteInPlace $f \
       --replace '$(dirname $0)' $out/bin
    done
  '';

  buildInputs =
    lib.optionals stdenv.isLinux [
      systemd
      parted
    ]
    ++ lib.optionals stdenv.isDarwin [ argp-standalone ];

  buildFlags = [
    "all" # f3read, f3write
  ] ++ lib.optional stdenv.isLinux "extra"; # f3brew, f3fix, f3probe

  installFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  installTargets = [
    "install"
  ] ++ lib.optional stdenv.isLinux "install-extra";

  postInstall = ''
    install -Dm555 -t $out/bin f3write.h2w log-f3wr
    install -Dm444 -t $out/share/doc/${pname} LICENSE README.rst
  '';

  meta = with lib; {
    description = "Fight Flash Fraud";
    homepage = "https://fight-flash-fraud.readthedocs.io/en/stable/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      makefu
      evils
    ];
  };
}
