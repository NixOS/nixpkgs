{
  buildPythonPackage,
  fetchFromGitHub,
  sudachidict,
  setuptools,
  sudachipy,
}:

buildPythonPackage rec {
  pname = "sudachidict-${sudachidict.dict-type}";
  inherit (sudachidict) version meta;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "WorksApplications";
    repo = "SudachiDict";
    rev = "refs/tags/v${version}";
    hash = "sha256-axa7eQ0jTo8GXJA5lwcvMyZLw9T573yeSo9xuvIm/gY=";
  };

  sourceRoot = "${src.name}/python";

  # setup script tries to get data from the network but we use the nixpkgs' one
  postPatch = ''
    substituteInPlace setup.py \
      --replace 'ZIP_NAME = urlparse(ZIP_URL).path.split("/")[-1]' "" \
      --replace "not os.path.exists(RESOURCE_DIR)" "False"
    substituteInPlace INFO.json \
      --replace "%%VERSION%%" ${version} \
      --replace "%%DICT_VERSION%%" ${version} \
      --replace "%%DICT_TYPE%%" ${sudachidict.dict-type}
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ sudachipy ];

  # we need to prepare some files before the build
  # https://github.com/WorksApplications/SudachiDict/blob/develop/package_python.sh
  preBuild = ''
    install -Dm644 ${sudachidict}/share/system.dic -t sudachidict_${sudachidict.dict-type}/resources
    touch sudachidict_${sudachidict.dict-type}/__init__.py
  '';
}
