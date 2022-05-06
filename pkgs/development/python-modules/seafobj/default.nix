{ lib
, fetchFromGitHub
, buildPythonPackage
, boto3
, coverage
, future
, mock
, nose
, python
}:
buildPythonPackage rec {
  pname = "seafobj";
  version = "9.0.7";

  src = fetchFromGitHub {
    owner = "haiwen";
    repo = "seafobj";
    rev = "v${version}-server";
    sha256 = "04vn75x4yx3lcvll69q4q0g4gbqlc4w7047x7hxan1zramjmdxfg";
  };

  dontBuild = true; # $out will contain Python sources, no build necessary

  checkInputs = [ coverage mock nose boto3 ];

  checkPhase = ''
    runHook preCheck
    PYTHONPATH=$PYTHONPATH:seafobj ${python.interpreter} run_test.py --storage fs
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    dest="$out/${python.sitePackages}"
    mkdir -p $dest
    cp -dr --no-preserve='ownership' seafobj $dest/
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/haiwen/seafobj";
    description = "Python library for accessing seafile data model";
    maintainers = with maintainers; [ flyx ];
    license = licenses.asl20;
  };
}
