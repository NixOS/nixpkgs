{ lib
, buildPythonPackage
, pythonOlder
, aiobotocore
, botocore
, typing-extensions
, fetchPypi
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildTypesAiobotocorePackage = serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      format = "setuptools";

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        inherit pname version hash;
      };

      propagatedBuildInputs = [
        aiobotocore
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [
        typing-extensions
      ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [
        "types_aiobotocore_${toUnderscore serviceName}"
      ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer = buildTypesAiobotocorePackage "accessanalyzer" "2.6.0" "sha256-Bit55lGYI8+VOEm+6NKlfxWldFWdiAFwRZjJsgwuv7Q=";

}
