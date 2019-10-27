{ stdenv, python2Packages, fetchFromGitHub }:

python2Packages.buildPythonApplication {
  pname = "broadlink-cli";
  inherit (python2Packages.broadlink) version;

  # the tools are available as part of the source distribution from GH but
  # not pypi, so we have to fetch them here.
  src = fetchFromGitHub {
    owner  = "mjg59";
    repo   = "python-broadlink";
    # this rev is version 0.9
    rev    = "766b7b00fb1cec868e3d5fca66f1aada208959ce";
    sha256 = "0j0idzxmpwkb1lbgvi9df2hbxafm5hxjc6mgg5481lq7z4z1r4nb";
  };

  format = "other";

  propagatedBuildInputs = with python2Packages; [
    broadlink
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin cli/broadlink_{cli,discovery}
    install -Dm644 -t $out/share/doc/broadlink cli/README.md

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Tools for interfacing with Broadlink RM2/3 (Pro) remote controls, A1 sensor platforms and SP2/3 smartplugs";
    maintainers = with maintainers; [ peterhoeg ];
    inherit (python2Packages.broadlink.meta) homepage license;
  };
}
