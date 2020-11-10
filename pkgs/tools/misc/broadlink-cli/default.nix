{ stdenv, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication {
  pname = "broadlink-cli";
  inherit (python3Packages.broadlink) version;

  # the tools are available as part of the source distribution from GH but
  # not pypi, so we have to fetch them here.
  src = fetchFromGitHub {
    owner  = "mjg59";
    repo   = "python-broadlink";
    # this rev is version 0.15.0
    rev    = "99add9e6feea6e47be4f3a58783556d7838b759c";
    sha256 = "1q1q62brvfjcb18i0j4ca5cxqzjwv1iywdrdby0yjqa4wm6ywq6b";
  };

  format = "other";

  propagatedBuildInputs = with python3Packages; [
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
    inherit (python3Packages.broadlink.meta) homepage license;
  };
}
