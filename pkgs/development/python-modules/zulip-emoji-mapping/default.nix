{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "zulip-emoji-mapping";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GearKite";
    repo = "zulip-emoji-mapping";
    rev = "v${version}";
    hash = "sha256-logm5uAnLAcFqI7mUxKEO9ZmHqRkd6CFiCW4B5tqZzg=";
  };

  nativeBuildInputs = [
    poetry-core
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "zulip_emoji_mapping" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/GearKite/zulip-emoji-mapping";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
