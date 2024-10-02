{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = licenses.mit;
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.15.1"
      "sha256-DALSwzPriQHPReCA4DxiqDE4egt1d0kVadDLqXSEV6k=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.15.1"
      "sha256-7VNgcslaFFeprI+G9Owfj24o8CFmGxqct4QWSGgxwI8=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.15.1"
      "sha256-ItdsLbXVs92zb9JDwuHHvYVKArUAAeDUdt6tPxNikV0=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.15.1"
      "sha256-JSvY8qqA91SUMXs7ajfVQ6wZFNHc2XisO2haiygJg8o=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.15.1"
      "sha256-RJKzIa6b/ov0xpayGBgDVW2DUjIo0xNfDDh2hAvK918=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.15.1"
      "sha256-TNhrmgAjuJLBLXU2dlp+Ri8pJ+swgjXu1lJFGUnLEfQ=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.15.1"
      "sha256-T2mqIUobrEepz6vS/VLWq8OpUZTYRMme0SgWv+UtxmQ=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.15.1"
      "sha256-oFgte9lbXb9IM3Ezn0Jmd5djrLwgJLqeDePdBb5OZrI=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.15.1"
      "sha256-3gDSD6Z28yicogEeDv2i/rcmh7X9nRWrwxRL0YFZIpc=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.15.1"
      "sha256-3NC66/pp4F8GsH40z0mBoaLqIKyPHGpgEAGgOnOOAGI=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.15.1"
      "sha256-qsiFXNECUVFDrreYOi2MLa655WAECXuPqi11z8liVN4=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.15.1"
      "sha256-QPhmF5urmZBb+e7KAIJihDujuDAopgQqrBspAxD6YJ4=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.15.1"
      "sha256-1rQCSuTShglGMwqcxiVULSbmgzpUZmubTgqlum5EeqE=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.15.1"
      "sha256-l/dJepTAEpsV3eJWzMbw43SrqgWuL1I3IVlVQQzZPSM=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.15.1"
      "sha256-v30RZvCTHOMxsypX+Id5W7VEPC4QFYvRklPu9zaJ9x4=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.15.1"
      "sha256-ceiFklxI0RK06gj2ZQcvpGyW903SOxXA654MzRy3A7U=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.15.1"
      "sha256-P9XULdNPREbu2xksZXIIxZUEggYlU3j0Jo7RzFKMawk=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.15.1"
      "sha256-nvNJsUkMwJd41vlj7pKEn37f1Ab4l4WAJbYGqfxCmZw=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.15.1"
      "sha256-/rMS/1K9dGzW89Rzd6sg9o/L56kNAO0bkDUTNKsKxxI=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.15.1"
      "sha256-yPEPmU3CVzddnsFd2CQp+eAji1+/bH/Vvhv6D2JbjvM=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.15.1"
      "sha256-gzzXHrMC0MF9RykwGmZiUtgufuRPrmGekVicXzdlFw8=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.15.1"
      "sha256-qbiOK2G95NdBTt1AmrQsDJbz885ugrdRBXMb9ZQcssE=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.15.1"
      "sha256-WYgJ2GLOxy/Va+ZY7DwwX7pBFF4zv1iQ8rptFoOlFsA=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.15.1"
      "sha256-9lToTikNN5kH9TCGSeQDnm6g2iM+1OGbtSpN4f6M7FM=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.15.1"
      "sha256-8NEZDefM/mP11YPnOCn11QfbWAMaCB5Yh2R9zQRtPpw=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.15.1"
      "sha256-JU7s8pqfJQptll0Kh3KPDeFULM2cga0nYZSvhLk2ul4=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.15.1"
      "sha256-PddQSNJ9KNGL8LQDD82+IeD4cVCR7huBkSWTqbYQfUk=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.15.1"
      "sha256-hUEFUNC1WdPpdu+9AQFWLvFhvBrmy3Xg7Xl4LlB4z6k=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.15.1"
      "sha256-E8LmUYpLqVF0WooWUXtqv4nhst1o050tx3/sRDBhd+w=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.15.1"
      "sha256-Yx/e2UIEzn47L4mQ61S0PkHBuDbz7uqc5yIw/6XrBkI=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.15.1"
      "sha256-vZJddKOLsljDKP4WrUDZrc4hkk01FtN3wL8MXKpfuII=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.15.1"
      "sha256-sbgwQEs21yd+xl2AuEiYEzc0Lgx7Uo/Ctibd2SEHY0c=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.15.1"
      "sha256-CThsP2a03VbAIFr4x2x0L2fLgIxvqFV1MuMLp1eoo6A=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.15.1"
      "sha256-b1M6ZdlrG/AM3h5iM/mMAW7SrwrjApF/K0kgbFpAM14=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.15.1"
      "sha256-MV6dma7+hf1ITv3HJ4cJZyfpimMT5MBuspTCEjMix7I=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.15.1"
      "sha256-24ukZo0shYVOz0HlrIj0g/xsfKz48fZHlUqcuTFvSoE=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.15.1"
      "sha256-/R22nTYf7XQBH9u8R10jHqHA4+s2iliX5+pFUyWdaG0=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.15.1"
      "sha256-UGogN6rRabJuNokJPeQUol9DOMBbc/pkPL+lRg5GYk0=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.15.1"
      "sha256-EDQ5H7R5U9AQnLy2rkRzSSAkFVzfZiWCqlLqP24wv2g=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.15.1"
      "sha256-7iJ+npfPI64WtlKYPLQUkJsJvhjSKCDbYBWWrv5dHwo=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.15.1"
      "sha256-BCj6/x6lnNdUx/FjP8mLzv7zLukjwDQw2/tWrFSuU0A=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.15.1"
      "sha256-GbRu1vn7S1bILtKKf75+bR4y7OYQ6WnlUVt0HQqr/8s=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.15.1"
      "sha256-7r/W5Hbv4J58aqpedt3ehe3E99U74sFiMHo5YnIPvh8=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.15.1"
      "sha256-TwBEzvuYmKyL5Bx2VCZwK0przb4MWhDVqOfl1RF3uog=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.15.1"
      "sha256-ApxmZb2xwj0Leynjqi5YC4stEt0qcWQoSq3HffbvL3k=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.15.1"
      "sha256-ngI/9VlHFOpAjcXi04JX+MVEdjs1cxC2UT+9MQTblGo=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.15.1"
      "sha256-+y931CL0UdxZd5dnkSkNBAOmyuXqSb9XdIwQUKoXDTQ=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.15.1"
      "sha256-Mv6fm2JLK4QVL1dTlVCIM1TaehUSlXTBATHvXHO26uM=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.15.1"
      "sha256-9koftVpoxrFkg/WWYoLZPEf1nnWxqwEeAzeMIJB+n8A=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.15.1"
      "sha256-1s+EM9O5Hfsa0qKK+HFrif2dH+C7+V51MkqvuKeYwyw=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.15.1"
      "sha256-lDC8Za+QGc622FVrsNKPCuitYzU521BC20g7ZGUZMAI=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.15.1"
      "sha256-911ynsQTCCv9kd4TgeWR5Hv8ulz/kCnYxnw9PWk41IY=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.15.1"
      "sha256-dh/wbIJ6VTU8++QGXa/IDUCcGpdzBB4jfaizyn9jfyo=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.15.1"
      "sha256-nnyLWvv9esKWKlyZs9j+hUHTCBs55qC8PX5st0OHBxg=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.15.1"
      "sha256-f8xrPRkEOrw1fFI/q0U//LjzDCymhPOBpqrGPas5te4=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.15.1"
      "sha256-9lTVbw1mtKgIiDsI7pc2Lmd7W/1OjMBZtvWTL1mNqxM=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.15.1"
      "sha256-hEASqSTOFl8Pc+qBZ0Xqf36JivPVgHbZ2yZszo5Z9Uo=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.15.1"
      "sha256-1L7UGZNkl89ULZV5LiajDZxQmLpelTsjNSvUzUzwk+I=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.15.1"
      "sha256-HaO/GSX14cKdKlwYmowzgWPfTDrUXyiyNlhz23lPyT8=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.15.1"
      "sha256-0vNZTr6RNUv2TjQJ9GZIwe6jTFJH1KgJW82fVERSFIw=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.15.1"
      "sha256-Mk5xbw1OhHcBDhohKu7emIz7c4BkxFA+LRtHrLL/LoQ=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.15.1"
      "sha256-i/a6O3B69uPMsJsjW2hxMdLm/q2nvRwTlcpvqg0zcnQ=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.15.1"
      "sha256-2i5cZ7cCy0zt71bTmAZHPCKR8GVutVR2TXeGJIlTQ54=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.15.1"
      "sha256-Qcz4JHpT34WKY0+/CRDavwiI99GCwxA/SBftb6Wi9J0=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.15.1"
      "sha256-qdVJ+6ELs5YKqIV/26Ar2FW4KC3DGofHJ/+xo5xzT3M=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.15.1"
      "sha256-wlpdAHtWZd1l8jYduPT0Dc0LIWxOiiA05uXTpL8fQWo=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.15.1"
      "sha256-zpuLoNTgcbYQJ0DF52qoPVm7nspMiITQczoREaCtlCI=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.15.1"
      "sha256-XYPt1jgk+BEjDpNH2XHNf0hoOwzewoxqxy+2qjv2dMw=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.15.1"
      "sha256-XbQ3BYHXGNb4aKFo+WegaZ8613FiVRdthZ0zU7borjQ=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.15.1"
      "sha256-3cifXhAhIxxZVRdE0Pt3SmaWwoj75iIpp6ThnLeL+BM=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.15.1"
      "sha256-8awRuy2iD9mYSuLaMrbpu0bZ1HlY9kIrF4/ZY7kECbQ=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.15.1"
      "sha256-n8RP98EO8AB0a3zqKlc7TZBttT7bHRV2EFYBy999q4g=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.15.1"
      "sha256-9AfqyTav6mIPiBrMGP6Rh+ytAS92LdLg/4VdTaSKB6I=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.15.1"
      "sha256-qTq+tsvlPDq9LDTNgZuwa1zva17PDm1zBMnDX5nLR1g=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.15.1"
      "sha256-kIF+sS4RpsmhiuttzwFViHaOLZ5B69O//hwEYGrMfr8=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.15.1"
      "sha256-hTUDhtsv5KWOiM9jYrT4/IW+GmnCmWnhMZpoQIClQ3k=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.15.1"
      "sha256-ffSs8Z/TQatJDUKmjdclI5DYMf5/EI/uEi8r4EnKFds=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.15.1"
      "sha256-5Sa+K+DTpM2YwTfhlufD9MxTk4pv+K1wE9PYKM1zAxw=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.15.1"
      "sha256-NfY/cGT+ft8bWitgYHbySblXNdYj/c/4p5jr2yOs5+c=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.15.1"
      "sha256-fQONh48vGKkr+ICjI3EqKW+jNXH/DSm0a96pTf4JQmk=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.15.1"
      "sha256-DNayl61Eorza7nIjjbxbFzs+lIN3oUwpDIImJEMHX7Y=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.15.1"
      "sha256-v9bq7ub+8q2NrZtaqWqQh2MSKoGfDBdTVW1qKTSooug=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.15.1"
      "sha256-9hBxeCltGrxtMGuTKTwVp/aHHccnfDKuI0QXv50uKNA=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.15.1"
      "sha256-z7t65Ioz0NtiToPkTIbYcBjWlJg1rcTIj0u/qmPkhMA=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.15.1"
      "sha256-/NyvlFx8/nOWClB3ZPqTt67yGN2ssYojWukw0S3v274=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.15.1"
      "sha256-DWf6HTvFyMYRiOLQrawp5GwhXniNS9mhwPNyprCYrt0=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.15.1"
      "sha256-05IkwZCPZvQGkRya7TdN1huFpMxuR1zxB+b8JSFI/oM=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.15.1"
      "sha256-n62US1ENdO1MFljx5zeLx+LblbiJyxefhN2+nlxu2GA=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.15.1"
      "sha256-knhkLyC1uPX4KjiFcgFf9ys2hCz38++q55nbnUM3n/Q=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.15.1"
      "sha256-JG/1ZQ9cSCMzqF6CVTIu7EIm0ORbLn3gM8gcCCSRhsQ=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.15.1"
      "sha256-Pyi45ZWBuEsb3GoumJkX+c8QnX3J6HobLFqwkm7I0ng=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.15.1"
      "sha256-wius84bAUyldt84o8qUeBSzajkY8mLco85rI4NAIQcc=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.15.1"
      "sha256-MF8CGeObwgB5LW1o1ynwahm9GZHTvxjlgNXDyFRjpWM=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.15.1"
      "sha256-+gyO2dno529rxF5Uj1pyQ0+fH1CJK7LJs/U4WIpRIX4=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.15.1"
      "sha256-qtMwQ17MpJ0K7zbKr4dyAGWEfHqfM+wXQe22raG/i1E=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.15.1"
      "sha256-qU+5PMZqxbskuB/ubXeigzS5t+A5m0WW0e4NVQjFLO4=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.15.1"
      "sha256-hQt2Htye+VubSHw+2Iz5E8IgzHGwAwmyYEkNI0br7eU=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.15.1"
      "sha256-n2NZxFSH9ymucBLagUAaWDgAN4kDsfKqB2W2ir6aEC8=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.15.1"
      "sha256-nzm7mnREUd6MEHan4cTc0MaorGo/X+eKbGH1/giG16w=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.15.1"
      "sha256-QzPGQirl2zA5m2yqqXjUC8MIsUDbOg1yl252KJU+Ipc=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.15.1"
      "sha256-A5OdqOTax+3/v6GG3IzU771A4l3OXQhqlowknE0DnNU=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.15.1"
      "sha256-3b5SI5qHhvVIa8hqLp/YZu9b3DDpZm5ogRv0I0NuI0Y=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.15.1"
      "sha256-enLMc0Vg+RwO3SBzvDd/nKQvNbCllMJMS4BBKGUNWuQ=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.15.1"
      "sha256-GOUkXglekGMNDlWdz9dyGvZpgSTfnZAh3e80CMvzumA=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.15.1"
      "sha256-+KZQnRFKF+0nmOqec1jHa0ewAcfLBoW9mrMVNZn6q78=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.15.1"
      "sha256-4d/rL6L/W2zfZ1naceSfH/E1y2DUNMcQ2tJaaKsRjLw=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.15.1"
      "sha256-AOhrrWLtKq5Wr79TcFNa+A3/MhHMnAPMIPEgcum2/ZA=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.15.1"
      "sha256-Psxy6JILUzvwmUj9QP2wTeIgt/nbtpbG3LUozN9ltek=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.15.1"
      "sha256-3Jt67THyNfn92g6L/GZwPi0HLb6bpLuoDAkuXKPZu1Y=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.15.1"
      "sha256-mGNHO2T129nPrODffC8Y9+R+XKjVVUnFrw1yDkJ0g/A=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.15.1"
      "sha256-wceBAH30EypOqb4GqTP6aL6Ribm4l6b082+vB4sRDMs=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.15.1"
      "sha256-4si+dqz/nPdXAF+eUkTICZQ8JaT+DcxEbmrxKZcF5G0=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.15.1"
      "sha256-4Ak5F+RnUlOnMvEhVTXrHXkQQzWSo7iRIojrwYifMnA=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.15.1"
      "sha256-Q1ZGZfpub4fceqFyBTLxj5G27ByHYPRH8KvEMyFZWyQ=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.15.1"
      "sha256-lHSPS5/HAW2NFg6zCKXARznJ1UjTWIn/YDR9XlMa1ag=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.15.1"
      "sha256-QXAAHqiq1ThUvS5Y59SXA0OKQza0IrxPUyGwpZ1Ft1U=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.15.1"
      "sha256-lHKKWM984zvnbcO2ord+XkbFm91y2OAJlddm3dongo8=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.15.1"
      "sha256-3XQ9EjRu2qfpvHAWbM7XHodvMCR5PXOzM5ttes7ggEM=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.15.1"
      "sha256-DR+GYAUdE7Nfn0X0sp3IshbfKjcrtFVCk3KObFlQbdM=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.15.1"
      "sha256-kIg535sFaySMannjaMHmVEZqx7Lh1OnGpBc/CxMqWzY=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.15.1"
      "sha256-rGvEfMJt7mmrned4uLGaN58ZGgFJzNPwxFCRu3SghWg=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.15.1"
      "sha256-gkBhNs6Cpy7dL4o/SyOxwF7eCwlnHaGxbSjO0FvPxpM=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.15.1"
      "sha256-BKyTNVhRzYjQDXwhTpo9rblgEonzPubmJIOrCnwaEus=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.15.1"
      "sha256-9v2x/BYM6tiPWPC/c7ZNJufl5EStBRq7dSW9S3jaWTc=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.15.1"
      "sha256-7B24s2z0hwaXZzj/ryhfIqbiFPaiFuC8GOn5MaYsB0U=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.15.1"
      "sha256-Z/Ul3IhUDhYjijXU9fFCOsG2r927wvl3pOWP+SxZ7rE=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.15.1"
      "sha256-ZNnWPccp4nnNAUk6tsAfV6xYS0U98rh17bTXG9+NjBY=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.15.1"
      "sha256-72IyOCvtGPR2JNpIIy0rgiACfmDfxKlV/wo5AvzTdf4=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.15.1"
      "sha256-jFgO3ks0u/1YMjeQXHvMYoa4O35+VrvpeXWIAeJRj2I=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.15.1"
      "sha256-5BewcGF6cDdPnTqyKLHlJIYuiv5N4GSuIlouRCEMeAQ=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.15.1"
      "sha256-fh2RP530haUdEOM7noDiBmiHf5Cv+YvF8S4Xoh84K20=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.15.1"
      "sha256-z4fe7DbzI2AIkCa4qBS4kGyPcgti1d/CPJCqe82OuR4=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.15.1"
      "sha256-V6uqUzVntsISmOUH9Mjy5DjLxiYkPN9k6BtQFwer4wM=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.15.1"
      "sha256-C/W6eBJauG9QI8MMc7hFzkN4A21RRMH6kSU5Wq/qXus=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.15.1"
      "sha256-00hMhRWJ4W91I6cG5IXyyNqjyxPFrwmbHp69EWIIkMg=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.15.1"
      "sha256-++YYod+5UlCzknDJ/0l3hwPNukO9o2M0CoZR0lyOTnA=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.15.1"
      "sha256-+fJrH77TQKCBoio2R3LEJLmUOtSXd9oaf+PaN0YyEdA=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.15.1"
      "sha256-KNaHkgFc1W6cK7nwt7ZibmeL3zMmO2/6O1OlRkrUERY=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.15.1"
      "sha256-JtP47qVkcTMtafPT/YbEu/CFOh4yp1VLICTVzB2LeV4=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.15.1"
      "sha256-CKNmGY362fvOEdm9+UvElI9U3dZhjY4sTDnuzBaPJyw=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.15.1"
      "sha256-LIEyxMseTo/G44R9gUeWFOoR/k1aZ1a6nLA8uuoti70=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.15.1"
      "sha256-YromFw8hMXBV3v9rAfmAFg/1MWMSsBR8jCjgnN3Qjdc=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.15.1"
      "sha256-UvwCZclRwoDaAMhY6CdhCADFs0m258Z34FVTH95CrZ8=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.15.1"
      "sha256-5vgqzDYe/y3vHvKFuYfhArZfmLHRPDuhGaSBRHWUiis=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.15.1"
      "sha256-2CPWpQt1jylh05MtxFIoig4DVoSBkHYVKEl0j/2s1v0=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.15.1"
      "sha256-aXAhRpaoJC0BR/KqG/0FF139mLFBTaqQdr0m5B8vz/k=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.15.1"
      "sha256-iVdmdRpw4/gj6Lsy6gP8C6HwvIKhKmKHpvR5HoB4jE8=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.15.1"
      "sha256-WVcWtkcrV0jTqCuygnDi6CZFVt/xuReFy6ji+BAjylQ=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.15.1"
      "sha256-Ym5Pxg3N++/QRdLNzHAOZQmObdroyhgO6tPHLmGfCPY=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.15.1"
      "sha256-OJmSfZaKAfiq7UImpgF/wKTzYaqxlhqrkOAbk7OchrM=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.15.1"
      "sha256-8Q6P8K87YIs+UsR5Vyyx9IMBW0fLAMqCu/LkqkUQYEU=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.15.1"
      "sha256-HkzZSHFbEWv67uQRIH6W/CsAFI1HpsFeNLvbqjQEJsQ=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.15.1"
      "sha256-SMNXQLSk9rFAXgEKXk23cjWRRvhnUcskkQyeSetngcE=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.15.1"
      "sha256-vRnjkeGogwcdtRFybEuqB4FjR89N0KR8pdDWs4caa8I=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.15.1"
      "sha256-j9yAFJUVBUtViPCO3DBCo1tC9AcLO2Uy4I2lfThBV+I=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.15.1"
      "sha256-k7D8o7sxTlyjmlCBmt2uY/FKC6KUWmx9LL9k2zedszU=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.15.1"
      "sha256-lozZuY4r9CkPi+SD9p/T35HyjiHVMmJ33GKNEZ/htPc=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.15.1"
      "sha256-3Bw3N2aIUzKNLyMGnHsxQB8bofonIcqJANariAKqXsI=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.15.1"
      "sha256-WZqYRDV21kkgBMb5z+6KKTlGxDJKXmMl1u3RlTPavl4=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.15.1"
      "sha256-/ArOj+prhHoDPRymOW4NN8IXNkWuE/wZJuRAXMVmzpg=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.15.1"
      "sha256-gE3/juMs0BFJZEq291UGWAh41NCRHWHmZY+KcZ9IFJE=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.15.1"
      "sha256-PRORLAzdQ0QmYSPYWrQaPSwW8JaeTyzg8Z+N8/Hqjz8=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.15.1"
      "sha256-OIvBSFt9S+SmZIjdw/zcC/FC/3d9Huce5jQXgj5D+ik=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.15.1"
      "sha256-Eh5fuYJawPwAFuQl0/wLq+gTJ02C5wFZsETDsOSi3LU=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.15.1"
      "sha256-jk6zZ3zX94kIfld9oXd6zW7ILhaa01XOt7c+/5pn8kk=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.15.1"
      "sha256-NJv1QF3qBn5LJ7yhKcSmy6W3OJ8kenfzQ4RkSRx8iTo=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.15.1"
      "sha256-7EDrF3TxDgLeAnbUeLQj7SpFPLB+uMjqc/sQxWaXYlU=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.15.1"
      "sha256-8k/FEmIfl2dKDt4JrCWdrLskYuj+A2VEHm0jqHWfUp8=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.15.1"
      "sha256-ZaDBuYlm35DRaiKv+xV2L+e/E5x1rGN59UTL2U5bRp8=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.15.1"
      "sha256-UgzrxIq3vh8dfw80VCue7gf8l19TqRUmRuAS/cW/G1M=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.15.1"
      "sha256-MF7n5Z70BFUAXaFuTDWIzFuiZ3u1fpYoZrBfRQR97Qw=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.15.1"
      "sha256-bEZV3TDr3l6Ogn49kFW/3IcFi/4NjQQnaC1LrDChlcI=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.15.1"
      "sha256-PPT89cO2FukHtnXQHgcNZie3vPCDBmbrfRDiZCZaJ1E=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.15.1"
      "sha256-Fez2At/MFggTu7ZtfKLWCm7iELH6gumBhn3t7KdJzVA=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.15.1"
      "sha256-5h9x9Rgb1Sb8wIQwRcjkonc2070QahwPkKXfQ/lFFI8=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.15.1"
      "sha256-JEye+bOxLrRJDToMs5jQZ2wcHy1K/2C5oPFUIRrtO5g=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.15.1"
      "sha256-j2gcnHFfWTVD3NatfJXsp3hRVEsy4930OclgR5IPbDM=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.15.1"
      "sha256-mnKzF2lgYtHTNEwecoqs4qt9hQ5m2xLo79/kZHFyF5I=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.15.1"
      "sha256-CCyhwWkjtI7wp5CN1MCK0M//bOu4ZGttbHJSUcidjUA=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.15.1"
      "sha256-+BlDjTPv+fmKmUInm6FpOQFt5H5atz7BWKhrt56A3Co=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.15.1"
      "sha256-hCTL2KBMt5p51YwnOYNcpGvzG2wvZjt23kK3FX4Qp5U=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.15.1"
      "sha256-A8BAADavGEB7sa+fh9SRahoqN3mne7ABZjcnZI9YfBk=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.15.1"
      "sha256-QVYHr4fbnZPozVghHOZVsyChTuP2S0Ys+876slONaEc=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.15.1"
      "sha256-uqZrNG/mOCnfYjNF5FQofjSUeXhnidunT1754yame7E=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.15.1"
      "sha256-hQGTDbhJNiJc5dORzg7XJ4p+ZatNcI0qoT70qtMHzHc=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.15.1"
      "sha256-4whyQ2X/R2eMdQ7DOygNQFqMgLA+w+6ydyN8s7yxgB4=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.15.1"
      "sha256-uD/N/ueijWNwibOrivY0r2HiQjYOuHQUONcW3iRCVUY=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.15.1"
      "sha256-wWghsiPCvWY7VX5XV0ad65nnG9bI5F+E5xEUzOGDdnY=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.15.1"
      "sha256-dcGUPUxGvD/ZEyoo193VVOhSJhoFkgwSjpOV1kX/vMM=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.15.1"
      "sha256-4rTqmcRB3HjskWJZLbQaPDyNQGHXmVVJqb5LK+EPH6Y=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.15.1"
      "sha256-CRluCc0/byuRlGr3uQyWg/MfCpPnoiS5inNLiYkhwCY=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.15.1"
      "sha256-q5ExCn4HAdAGISDIRckrnlmQ+J1RDNgBa5hmYSJHtVc=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.15.1"
      "sha256-SvJor9naL/MzyTtHjOn2QMNnLYXnmHYH11DuWg0+y/U=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.15.1"
      "sha256-68PGFV+fSjjwAq4SoiOAaJXw1jKdQegFgz2UeHV9iL8=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.15.1"
      "sha256-TrP432QWYmAmnka3CiWklZh3g/xrLhGJVw8iWLR5f8E=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.15.1"
      "sha256-0+nIbuZeuKIhQiC2+kSaDztMLOUe9rZ+guDROGM+YI4=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.15.1"
      "sha256-lJq53Sxg+RpZSeQKG+nu0EhRQEEUSPoWqiORJUcoqEI=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.15.1"
      "sha256-RZUktF80I0PXhIPEZJav1i1a4FyFSyHODTeUsIcDHGE=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.15.1"
      "sha256-xmPCGjlO0EThkhUWy+VlHLplAx7f7+zXKzr5hb/1e6A=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.15.1"
      "sha256-OJeNrERgHfCYfgpn+DMmo7ZgUujg5G3bQpedipAxbX4=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.15.1"
      "sha256-0tSQ1wnz7R7KaRVsoNGeUcbmf4cRBrUMArCEEDJRrtc=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.15.1"
      "sha256-gq//bvGswyJgLHypO0vC0rUruMvr5DH0TQPgxb6Xkrc=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.15.1"
      "sha256-E0hjBGm+mIW0wG8kdLAhXc4BzMzJK4gESiyS2xVIEpU=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.15.1"
      "sha256-bHWlDRHqZ6vYcsM01peSdcQ5oqvSGiG/UHWlOinT1QQ=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.15.1"
      "sha256-PrQPNUQI065kb8+ihArJOroydrAbOhFdS2yzq55nTKw=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.15.1"
      "sha256-2/pUMsZsuW44TpNCdtciCJ9z+Z7aREyBMBIFdV80lgU=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.15.1"
      "sha256-QIaQ06qrpPa4nb7PgOyhbYH1Oz1KL1dwwy6/D60tgKk=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.15.1"
      "sha256-+YxeyUt3GqsliHI/T8ZMxfweAhnAXWHLxBZSNbmPVDg=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.15.1"
      "sha256-09o+YQysUdNGoNT+IXaPIOCSHUxYFXezjxTvqPPWBNo=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.15.1"
      "sha256-yDovPCnikCe4qHPCyZPZEu7UlIHLW59EySO3xValmgw=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.15.1"
      "sha256-BnrpdnphOkjk9D3MuhMEEBFL08NZE140o4+VR1Rp4O4=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.15.1"
      "sha256-6ona+KE489SPJSlokzwpiqERuBgWjqIYofh1rUmeKwo=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.15.1"
      "sha256-lYBb737JcKQa5cKm94O1C/psjuRNFFNftn3dctUeOnQ=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.15.1"
      "sha256-9Z5s03sTVEzzXO43CTuf+YICuXisAZ/OGFyH44KOuF8=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.15.1"
      "sha256-Oqi4SM+L1FQLs0jfyWXILG/XHs5X5K+5jvGcIr76OeY=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.15.1"
      "sha256-RqvU6K50yGzVQBSzS90htrFOScpondnyceN3ISshYlI=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.15.1"
      "sha256-j4LVmlaI8tuJxjkweiZRWgnYlR5p/M2u8JSkMg3Yufs=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.15.1"
      "sha256-yQDw0I8jlsVpL8MSerOV66yRdCE5ik7R/v+rkBAzKrk=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.15.1"
      "sha256-2XxADXGruMbzM50bElDkwlKQZ/r+6HPhMOjj8InGOlM=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.15.1"
      "sha256-+VYnuMVf16mrgMJ5DMqdy6CPLGavuA0gUW1kv9Uu9rs=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.15.1"
      "sha256-2WEJoWXSfDmFl9liWtIaviLnAHgRA5dAamQx1YfXgzE=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.15.1"
      "sha256-TK9wWp3GEHhn4jypBdQEeJZp31IvKFFTuSLKxqxZoNU=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.15.1"
      "sha256-E1sWcLfHIlFelP3vb0yfhRpcyboyIutPrF3ByCNJITQ=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.15.1"
      "sha256-EtmxI6j5SlZZcv+YYsDki6VcMdRhZWEoJVT5VDFV/0g=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.15.1"
      "sha256-xiDYqvt2e7MiAe8nCQR51q5Ov8B94eYJhQgN+lvFDuA=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.15.1"
      "sha256-0SFOWAIckxRoWupRztC50CkOKqtUuxdNnM44SnPLYwQ=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.1"
      "sha256-Hz6tsIdCcx5vzwD0PDmPKSpjqYEYENAiZz7WuZC9Ago=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.15.1"
      "sha256-abqiY/pGLnV7UzoojcX5aaUtKC//y5UFYG8XoS9hJgM=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.15.1"
      "sha256-5k0LPHH0qUlEEAV6ASredhR65Phs0133c37N+YB+tcY=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.15.1"
      "sha256-4VqaoYwKkNckmb4BZDbWPLeEVa7tCxBD8g6pGQrr0Ng=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.15.1"
      "sha256-80E81Kv3FzkgGQvpVHxmYqnNIRtureOvIDmKdnUo7z4=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.15.1"
      "sha256-bAAgU0b33CNXVK0Q9ynyPGbL5KBiQq6sT/mL1pWJpD0=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.15.1"
      "sha256-nVywDMlzkITUEW7K6FWoYz953wAqCiUemT0tu48yO6M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.15.1"
      "sha256-N7VzNLh+LCFrfdgmO982cau3B/d5uGoGO43vMMpTNBs=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.15.1"
      "sha256-NpjX3LpbF1CajlqY9ow4GqCVjlrTBVT1U/Gn3wHSQTE=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.15.1"
      "sha256-lFRMsg9LhjizD8NsSyK209h+xtvYgTmJf5lc3OQyqdY=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.15.1"
      "sha256-mdhrS+4Cg2VgH5AWroB2i5Pe6LEFfn9J9rEe+UQovxQ=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.15.1"
      "sha256-Lddnm936PSivXBygA44rgyd5wyPoPDns5XIYbQfQ91g=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.15.1"
      "sha256-jTgsyYOLrTYNEfyhotGbbTrlQkTKqmd/0uKOMvmm06U=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.15.1"
      "sha256-RULc20Hv5VUT+MO1/hj+LlsdL88c1KuChWjzYY150Xs=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.15.1"
      "sha256-3gl7NVGwfh1jy8VewE76+Pe/cPKQitdnC3JAau1S9dE=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.15.1"
      "sha256-XnuLw62YOZN+EwJ6b1ZQCOwhIqzE8ntkrgmuqTY62vw=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.15.1"
      "sha256-g8pzgnV5puJSLogXJrQn1zhYiOB7446R4xkxOQCwqSY=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.15.1"
      "sha256-gZJM4c3tSilImlxeKWU3szTmpnXxpS6kAvF/zKXglFQ=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.15.1"
      "sha256-eXcDiAQjLAObgX3gfGtlVL6BNK8fq81f70tPNNcKJJ8=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.15.1"
      "sha256-OPJiALIiUDioRjXkeLtksPBMlmsUpIRsZtuoTESnKpU=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.15.1"
      "sha256-SN3dXMpqcuJcWnpeUi4Jwtat9erU0KdSjfEbyf8pHXc=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.15.1"
      "sha256-Ru3j6tm6I+wtpKzkxBSFCfAleI52WnOSqgvlCIla9fE=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.15.1"
      "sha256-U9FwTzLVdE0UbAMTjMjrIMlRVlkuQRzKiIEd7ZepOWA=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.15.1"
      "sha256-FEzR+YjEGFKWbihsat2gaDp87fdIPDCmeRv79U08fFo=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.15.1"
      "sha256-7OB4PIbZDsnXqLp+9cXd5ER5QIkUpjtJk+A+jT0286Y=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.15.1"
      "sha256-MBUaIQIThP+JZHbVAU5r0yCHQs13wLAU87y1gRECFHU=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.15.1"
      "sha256-yES1WELzrI3Xz0F4S7y3NajtNTQO10S3hi+pQsZ4KVE=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.15.1"
      "sha256-ISAoyu08TEXIr2VONRLIvRDaAOazDPEtPp66/CnmHv8=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.15.1"
      "sha256-eruqWUL7Yje7OJlV1arhKInqnXChEmI49nq75j4ZOrg=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.15.1"
      "sha256-/7+C/b51gkVW8QXyXg/5b1vzvTtZXS5ts9K6PWXAZU4=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.15.1"
      "sha256-/joJicKfFNQhy24zZp6vM/EmGZGBTwPTQ8w8KHv6CF0=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.15.1"
      "sha256-btYigxx5bnWll5u0IHDVpciY4ZV9dOxPDKReEv1i0AM=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.15.1"
      "sha256-Kn4uM9F1UkiWGshjX62WD5qROnnTw6TgG4bPv9EWz4A=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.15.1"
      "sha256-cOu5LEVvs1VdXyfgtM7PYzIUsNN1l//gHTiY0ArmFf0=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.15.1"
      "sha256-9A4p2lohJEhOcL868mMJcmmjYSS8Gd/5ShbkvTunDQs=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.15.1"
      "sha256-s+maghPzS18nSG+ozOp/hKQJRHZHwPhsASqUXaOs6Pk=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.15.1"
      "sha256-aLCYGd8+LIgHxsR8Qr+rrruL5JERkn1etCL3o/A8sZw=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.15.1"
      "sha256-e8WN5g/vbWaYSNMZS43GOkdx6AFL15cPUvZn0Ufsvqk=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.15.1"
      "sha256-/WiO9zp/YK8+2p97cbY5GwQcb1XB5i86QBlXERTDxk8=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.15.1"
      "sha256-hGUdTC5ksWqneEqIROSc3XqYANVrtL2caM+OqTVnlcw=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.15.1"
      "sha256-zJvPU3lXoxxw1LF0HkPTfO7d62Q0mTCuqGKQT/8LbPQ=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.15.1"
      "sha256-X1hQ7pzhlsD9AcD2JdM/1u9W8PGRFnJaWhArHhZLPrk=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.15.1"
      "sha256-VjjHrGv8GuQ+4Fd8meBih98YxFpVChvusBZDKJ7jvAA=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.15.1"
      "sha256-p1N0+9s+QDRoSkgiRtsmyGrxmse405CDwuPW10r2TFY=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.15.1"
      "sha256-L27J6hqxLMwxm8r2DK3xc7LrtNOgt5HSBE/YsjqH9c8=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.15.1"
      "sha256-njXhqJ+7xnxabYnNqknXA67I2J88jxHk9oErziic1FU=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.15.1"
      "sha256-U0jzrXqfz/X/Dg1S03/is/xkQwIO9ICwg5s/YYImBf4=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.15.1"
      "sha256-PL1oQYboRsEDlCACZ/f+WORfaj/3pv05XyyZf118cl0=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.15.1"
      "sha256-P4Iq5h9zo7y0UIcwLml8cCjjP5wKgtxP2EX3KTVPobw=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.15.1"
      "sha256-3WO3zTqIDqRR+bkAdsEg8KxruV43uUKGV86c+7jAKgw=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.15.1"
      "sha256-nm1iUImUWba9BNV0JUKC1uYWxiFTKLCw3vUBsuqd188=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.15.1"
      "sha256-VDIAA8d4/zv5pI1frk6tFZJ9qWtC29b9rZdIYN0YYLA=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.15.1"
      "sha256-3IyAJHmya+ycc0do6H4NZnhn3Duhj/ITiW+b90x7d8o=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.15.1"
      "sha256-kwB5VOix83ehKTJ6cXvR5aHO5ogYQvg3+CAnWEFll1k=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.15.1"
      "sha256-qGMnLC7fZA+OEwZNbfCQMJFiwO0mf/1chvMFi0CpIco=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.15.1"
      "sha256-oDvjSp0rQFBDclkyLifawL/hobIcT3RuNXS3IuJmG+4=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.15.1"
      "sha256-ynKSN7dB42JJw6DQOpLjwZXSrNvIgqfYrlEaXKE+agw=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.15.1"
      "sha256-GW0b2GWrahRsWM9p/sS896CLotC4NlHC+Tyya4AbANs=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.15.1"
      "sha256-xT0K4NB2r9ajVEDgTr8tAPtUQLVwZj4/q/9lFxNoRy4=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.15.1"
      "sha256-EKfd1G+A7T5A/7h+ZfWm+feD7VCEUU+RohAM8804Th8=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.15.1"
      "sha256-fpMpgVdydbNYhse3LemZWeu6pvLuXWYy7Nt3+CSedl0=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.15.1"
      "sha256-786gr8xrz39LVOuU0EYtyBhUxDbo3YEH5UXzmY4+xSo=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.15.1"
      "sha256-JUC3Sa94XRotK9rTelvMVG4TUQyrnVQ9Mdd+byd4A3w=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.15.1"
      "sha256-EV0eNjxdjT/JNuTip75SuCVDZfvQz71UbIgUHWfbakc=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.15.1"
      "sha256-GW4y+JyGelERL39KPMOcF/7+pwGBuPwKhNwecBi5BBg=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.15.1"
      "sha256-ONJsSG+d2fSaoPyrchl+oosIeVSjwoN5d0BPolDhhbk=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.15.1"
      "sha256-ggAfufDDaW+LdNindZoAR1xeWr+hQKr1ImTl+nGE0B8=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.15.1"
      "sha256-zUBoLdhvpvI/tTza9abj//Hkc59gMe70kqEF1SEW+FE=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.15.1"
      "sha256-M1elV0BE1RyFOo2XlKVIt5gH1M4bIU7rld77+cGCptg=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.15.1"
      "sha256-fgFgmDsx68FgZHOXTrJEB6OqVOlaVWgSer29dKwiBJo=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.15.1"
      "sha256-NG2E4XxicGVtpLqi8n/j2C+BsxdMyWb554XX/HlnExI=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.15.1"
      "sha256-/6OTsZUTgwYXFzTf1G8hkngaN32L8dPJzgdNMSXisfo=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.15.1"
      "sha256-H3mZA65etYo+frlSNEMs/lT8G86oWbNjlkPefoIc6AA=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.15.1"
      "sha256-diE7lw1LMxiy4gRam1zymw98VJGKaEWwQ5FudCma9ZU=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.15.1"
      "sha256-jeklWyR6ArvO9/i/2Iji+YbAsv2rnNLqKoSTBL5VDSQ=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.15.1"
      "sha256-I+Cfmn14B9W1O/LBNWZZ9384H0DexJav2bkc4+2zV58=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.15.1"
      "sha256-1B4R4cjzz3fnevwRsT4o3mzlzw4tXbO1kENgWOWbU7w=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.15.1"
      "sha256-w2iD7ZpVIIDRuTWikJAp3j7j7jBfcpPnKXfTm6KWq10=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.15.1"
      "sha256-+SZAFFyf+UTytFecjCv/MH9VykOCxFxXJEen1DZdljs=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.15.1"
      "sha256-kaiXmu24wDGIzDtXJ2pT87Wdr3zzRioLVU5TjaNVsRo=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.15.1"
      "sha256-YvZxBJGNtRVSsJAtv46Nq9xliVvXShiI2exeir+bp8U=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.15.1"
      "sha256-U/VvZwz7qMrnPjgQUL0NMnNS6e5X4PgW/rjwBi65iAU=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.15.1"
      "sha256-CI9nNt+zfztYT6DwgjAe9RNtebegPAAsSl692FBF7hA=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.15.1"
      "sha256-x/b1hpCTHqZcTJTzwQc+pYjdOYCiyQdsLw1vBpuPQyc=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.15.1"
      "sha256-3N8kaI67M6xKuTsESi/x4FVXy2Lsdoc9RRGIo7bKAok=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.15.1"
      "sha256-Fkl8ZgS3DD3hRYWQHl1cM2RCNHi8tWk9a1fyCQa+/KM=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.15.1"
      "sha256-23gDeTpYf9sNK2ARSPwZTkNSlGIze8ybLymQ+X0cf74=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.15.1"
      "sha256-7uJXGduh2yrj0nLWgTyELxdB6ZaU7TX35GywXTECU64=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.15.1"
      "sha256-qTAoxjZnze1ffC/QdVnCRy37H4Tzc1AkAERvvtVxkik=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.15.1"
      "sha256-+MsbvjZLLdY/JOr/yWBvrfHQ3SEWvUtzvaImsYNX0YI=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.15.1"
      "sha256-4YKcuhem2grrKP2I0y+fayyQ4beVhKQJ7KAC70TgN14=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.15.1"
      "sha256-DDxzE4KcnC4sjVgBMt2cldFgm2JIeA7pRR7lqocvXN8=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.15.1"
      "sha256-LMs2iAbogup0JrXFBIJhpgn8oFuhH3jGnb/Xh60xsMg=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.15.1"
      "sha256-fpQ5fan2CkWJrnir65tBHyXAqSa1CVQXt/Q1h7NiyjU=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.15.1"
      "sha256-W/uBm0i+eNsPdSpZ+WvxSRJpZTzRdnt4snregNIeghQ=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.15.1"
      "sha256-ijmqVcESbAfQLCgWhIEqq1+V8fChp1Pq0IfeBjmPtPM=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.15.1"
      "sha256-mDvgYxDjVc2Z+IGCiaNR3xOYuht1LHJPW1lViQsfsfQ=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.15.1"
      "sha256-HLjYbm4OK2gvKMKBkNZytKlChMW43y8g2k0CMVVvcGY=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.15.1"
      "sha256-Jx3U+EzIZzTntyq5YxlSJkHQaGX3JkKqCOlHtGqO7vY=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.15.1"
      "sha256-h1eonOUwVXsybJ25UfQwZtZWuhDh1v8M10ZT9JM1NVo=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.15.1"
      "sha256-6b9c2UdaNHM3/GAiGWFnZVR7sUP+cUy9Z5W3Ig+7fSM=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.15.1"
      "sha256-bLQrTDUhbYOTYY+KvUxMwiHgPFHrAJxB8Yjy3TUAMCc=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.15.1"
      "sha256-+cSgukEugB7RSrkWsEgbiMS6tvjAJDPwVP+rVEsAMJE=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.15.1"
      "sha256-Hf46I5GHQyLAN6IXL0X0VN6Mr3CsMhhPFKqx/fDrHv8=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.15.1"
      "sha256-yxamVPkF/RexBvdBpjUi8rYzEy5jOf15otKqi64gnOc=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.15.1"
      "sha256-B7Q0TAT7rMWVZf4wSE6qGxMalHwvV7hPrcnCw3vcQkw=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.15.1"
      "sha256-ybBzzhKX3NClXHnYR7GBpQZGsF+xPprHrbHgOjeR+9U=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.15.1"
      "sha256-YPYrL6RRL0UhABcDZXpJQ8RQWDvPkD+y/qDQ1PbLCuU=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.15.1"
      "sha256-fkKB2Cmg0i/OOJKkHmLzU0UWkUDXVAjXYmBWpal6pg4=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.15.1"
      "sha256-f5xAh/57zMcvjJHeqDDSrlSx3u/J3e78oQmGVSyD4Vc=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.15.1"
      "sha256-j1yGNqM32RKzz5xmL52+cwS9JIj1DUIJQatHz7ZjZrg=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.15.1"
      "sha256-0rngVEUa9yBIeoMC2dKVVDty4DAiesQZJRm73C4PAhg=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.15.1"
      "sha256-Jypse/lhsvGWfu8551dngM+Jp8BdIp2T1WRfqdV02ug=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.15.1"
      "sha256-o2n4u7wgJPSS02LLZe+PLsxdwm5r+0j3VzDFVnR7bGc=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.15.1"
      "sha256-PQQLKPZYaCqIVTXS8PWAjrYjp4ZTMl1XDuvz27s10sY=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.15.1"
      "sha256-eU+8eBZ52BEAqpvHWJ4aVr2kuz6/6fMu7yu4bA9f/TQ=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.15.1"
      "sha256-+lUuiVz/wqkuH59QzB8ZIv+bvNGeNZvBDzUctYd6LAg=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.15.1"
      "sha256-+MKFgYPnSmSLjE9YP8fDjAo91o+mYkN2T4FbOMVSmnw=";
}
