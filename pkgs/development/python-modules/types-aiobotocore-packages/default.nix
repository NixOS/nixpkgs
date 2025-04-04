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
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.21.1"
      "sha256-R+eS/SwpXvYD/Up9nb4Z3ExnyopPYGzZpg6z24/OXu8=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.21.1"
      "sha256-o2IDu9EmXGs4FZfMrsJI4rJ3G29zwxBPVJsVXtbVc+c=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.21.1"
      "sha256-qdynQLRdzthq8+XQ0r5DuGSVLN4z9E9KbktyUQd5sKc=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.21.1"
      "sha256-IxBX7oKoVwEORX3G5BJNQDxbY+A0eeux/XPEP33lgIs=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.21.1"
      "sha256-DETTWKQ4iOinLnaeRjtcX/ZGq85/mmwUuPEFznVzPjM=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.21.1"
      "sha256-sXQruc7pLQ3ZbQirl2X49e2tlryR82smLGtDuJq4V2I=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.21.1"
      "sha256-z2Ge44ACNnNvvlsv62ZDYPDQVbyvnoRuU6zNLaKSUAQ=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.21.1"
      "sha256-jHP9M1lm/bxoC554aUEvIZwbjI41xPoe9G/nzD/o69o=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.21.1"
      "sha256-I2YTk6DK39+9dRStf1+PBulJ4MVDdlFTx4S0D4RQXuQ=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.21.1"
      "sha256-ag/VXv9rhXytwnd2kFgdYugHm1qQt2KOuNjQC9i6FY4=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.21.1"
      "sha256-DD5Nyp0sg2G9qKuOKoRRhLK09Ukumd0TnWsU7qA7+qA=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.21.1"
      "sha256-3AUT9YIX6ZuL2oekNXIXK9MP1Y4SQdHBqry9a57Wf74=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.21.1"
      "sha256-FSrA/osaQWflvrdLIdNqMq/LqkEyiaqaUPyjUkxyoRI=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.21.1"
      "sha256-g+OXyhM/M6aPPE11VCBAsSZYjGPeSYqj1ljcf/YIi+4=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.21.1"
      "sha256-xGGNh3jUDqfzNGDYm1L4WvdNVaBIXS5itT2efIYg7D4=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.21.1"
      "sha256-f4penHxLu9qeDZ5aWn7fMF/tVTdKX6m+tZl302ydgoY=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.21.1"
      "sha256-HV0uepBpTrWh1U4h4ck8JEr8bBJWYpmnqHjoWhLzQFg=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.21.1"
      "sha256-Z1wQJfl0ZomZAU3lQ4UzbQO+uiQ74Rey37BcnzdjTHw=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.21.1"
      "sha256-hI5YTdWdtjmchklloBPnTWoMbX1E/bFuIsfZukeLdn4=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.21.1"
      "sha256-ZXXUG6vHw1pNsOSX7pXZeAJRnvGMa2AAeEXi7KrcHTU=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.21.1"
      "sha256-D2LvgUtFsiQRqgBtdmw3QYGSDzBuOwX8bkjMJnjTE30=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.21.1"
      "sha256-PA8aaGP984bGVm8kM6BIW738I18t1LsDruFUTT7kZ58=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.21.1"
      "sha256-Rkm9muS6XFmTL099gHlpoy28qFzpgHu8W8SomBtYfwY=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.21.1"
      "sha256-wctA6qZQCRg6JjK1YSr8VNpa20fKvTQmgJ8pHLpJC2I=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.21.1"
      "sha256-NWNs9RBNVmcZojUEjlKffwEA3K0uBZ4WyKY4Kg5aASw=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.21.1"
      "sha256-KeKqHwKkDtjQlMCo86zZmjIV5Obw/3tGh3MWZcazgmQ=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.21.1"
      "sha256-gmOzVMqFQNlrz5mMqQ7YTkel4CKRVxg/Kp0C0c6dr/g=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.21.1"
      "sha256-RCujZIHW0VExJFxmSck0S59iV9q0XzBXmFLY8HiSeIQ=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.21.1"
      "sha256-pyelJU5rF2SWGNUvYk1fOluaEba2wSdjYoXBpcbhy5M=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.21.1"
      "sha256-pMhtrSo7rglrq3BZ5jllEQinRV+KnXExJ1CPmRz07ME=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.21.1"
      "sha256-n7Cu0mVIyPKs3M7VaZ0bLumcNxO+97iFbyMZjjn3zGQ=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.21.1"
      "sha256-giAv7smnFDohm5wezUM8jFema9qndvPeoSUjxKJlrzk=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.21.1"
      "sha256-KzBnZjeyklMJEEIvYtJTg7aBUrFZIjAOaV7il8imVdY=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.21.1"
      "sha256-ivE1di/B2WnmNlYrhhIYny0GWFrkLUQsx1czDdQ+4kM=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.21.1"
      "sha256-Alt12cn16zFDO0AtkWJF2vpn8ABaXl6D3M7xtsuOCDc=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.21.1"
      "sha256-eDLFjNMC8ewUfAVlTN+bkfR+KA7CVUwcm+bLzA/FLR8=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.21.1"
      "sha256-uqmvalAtZ5m5X/Rr37A1bd01tTwLFnNNjxsAglDWO94=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.21.1"
      "sha256-G7oCXpYpAojcsNeeO621BrksYrN1f5ltEDD1wlEr9Vo=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.21.1"
      "sha256-V/NbGwkv8kgKvgzPhnmi1eGUKTfYG6d3CTb2+Ha8Fvw=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.21.1"
      "sha256-4ZVU+gU2X2EIeZsGrucFedWiNTyRFyhtQzPMynyhMfE=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.21.1"
      "sha256-9vz8mu9HEjGM34mszuYRtSVBipwFWCxIlM4lG1gzCME=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.21.1"
      "sha256-qBoqBj0fkCmAdArPClPYuwumudHANEo02eCZKZdEFLk=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.21.1"
      "sha256-Rkz8LBCUpeS1L3ygyIihWaIzQCjgp/gZ6sjZoEIXlzM=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.21.1"
      "sha256-VGc1/UiJ1jo/9sGZ3lPbmP+XuzDAw9w3+sQgjePBKeU=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.21.1"
      "sha256-aQD1KjuILIAxKm4HKsIQOBdGc0BnPvswUd8hjIaoUr4=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.21.1"
      "sha256-q0qrN0m/fFp0dI+LfSC5Iis41GLYsHy1FiOUsCeMy+8=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.21.1"
      "sha256-OZuVZ05ShycwY4Ncts0nGh8eZPx5jvR8vv/xalhJ9PU=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.21.1"
      "sha256-vj0c6j4wi2bGULZQWxcOF55WeqGp07ET9LXB0I95rVE=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.21.1"
      "sha256-X4cI6u5NjMu/Ie8QGi2MGjoktDHuwVPmq9Bl6tdomXo=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.21.1"
      "sha256-/MscWR4g4aYw55GQiKGgGa60pERS2ymkl6MZ1qOcEc0=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.21.1"
      "sha256-JE2iqT64LSfP2u3DnWb/M3S9d/1iheC86n2LpV0O6/s=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.21.1"
      "sha256-c4Y+xmIGCFrpqN1Ati/FRQV2vDvQ16jfnLqoVh3kHzg=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.21.1"
      "sha256-+6bEorhFjXimrTS/exXRfHO8lC+mQZX1D3OfCP8ZP7Q=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.21.1"
      "sha256-OsdE715yYQWF4xyTG/gWFS0zWqHHdOQzYRDAerf5lCw=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.21.1"
      "sha256-7d9m2pV1dNhhdIqYTVYdBjjOBfp4NOg4EKVmZeGe8ms=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.21.1"
      "sha256-bZGtY5eDigEtK2BwQXuLh760zajIZCZH0nHCqzU18+M=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.21.1"
      "sha256-X34OQC2R65KDrO7j4UJ3KB4Z9nYkTws8qq0z5YHG4Zg=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.21.1"
      "sha256-iR+2xBKJAXACNjYuK8M/Dq47uZYdTqISYU6Khep2yQ8=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.21.1"
      "sha256-fVUNEpr3kp1DfO6lZviAvQgwRFSqu+bIFK52tYchCcE=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.21.1"
      "sha256-Qy/gk7km865hKHWZCTBi4Ido6hS0fbDku/ZEY+B0ii8=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.21.1"
      "sha256-rvtqVY3PrkIZjzrZMtzEs/M8bYa3/M4f9ebgoJumXo8=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.21.1"
      "sha256-XQph+m3o9quipYsplx8APTZm9Z5wzAspiDiF8tOU3gI=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.21.1"
      "sha256-NSQa8mDp3NCGGHGbNGwZ7ef6BXFCY5oI+cCve3Ip9J0=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.21.1"
      "sha256-g8rKiEKPK3/rAJeA08f3rrOl+iFW+rHssic0atIvwmM=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.21.1"
      "sha256-W1cgHLrr1AM+Y/cUNBpJnobgpKpiIXkIoP68yI5dFg4=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.21.1"
      "sha256-nObUucKdDu/H1npNV4vXKbRX7mJqsOaczPm9Z+Ggm00=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.21.1"
      "sha256-jSuftpDX7QIQxyWLjbXQf+yTsrxU9I5mw62dIEuAZRQ=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.21.1"
      "sha256-n7mXAF/+rK/UiowF9xcBXeUVMIT7qlBna832bS+ZCwA=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.21.1"
      "sha256-Lpbi6Gb3WEaIsduI+zX4aaYPwIQnGwcWbza02BFOj5I=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.21.1"
      "sha256-s/IlyM7tQ7MoZsYXi87YbEQ1c0Ltc2ExdqQrrvnNhqY=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.21.1"
      "sha256-/rJxXZ/cWqnXSFwKafXnzLYEfBdfPMIfdjG7tch+sUM=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.21.1"
      "sha256-cjITes1tjqGzUVeeXBAHkyn4ag+7RrSu9+Uf9BxCbtE=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.21.1"
      "sha256-7MSpyNKoWxNe2eKoVp5YwnWq2OnIelavdOMkM6hx04U=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.21.1"
      "sha256-co8OSZznzPSTs4uabn5d4Sz7ra2MFuex1iw3lREsZtU=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.21.1"
      "sha256-/7xq7nE+IFpbcZeuqsI/vouwdWl1Hq3nW1SzhgtTelA=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.21.1"
      "sha256-rvhvRN6RTx7bDldTZYX+v7a8tTj+Nzi3q8dfiKcvm2Q=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.21.1"
      "sha256-xeKDuX6WiSZD6jPuNTUENgVlZ6IeRylGiqP+JRxdCQE=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.21.1"
      "sha256-L1jsMh2cVtB6OVd6QvNI09zVo+WnA2tQXyGjov8zWVw=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.21.1"
      "sha256-jM4A9UvrtlVbdGRfAMLOvWs3nBoQaK/J5w+bJFvK7VI=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.21.1"
      "sha256-IynSuFsdTy6W+HDXrpP/XHxScjTIdEmlNHuI9aUXSu4=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.21.1"
      "sha256-QHdMv8xVWNIAo+HRKa6u8el5eUjHdG3wf/CTn+x2Taw=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.21.1"
      "sha256-WJvyQYJPimFbRlRap8fbpRb0SFSehUPRblriemrXm94=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.21.1"
      "sha256-fyLcUo21GTs6/6b9ZBADIhmDoiQ0PAczcLVtByDkSM8=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.21.1"
      "sha256-l3+a19Ws2psD1tAf7f2CWJUcr2euQ/q6b9BcvEpwIH0=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.21.1"
      "sha256-Jv6UXWT4i2k4HOsztJP3ulsPT3QBo/dYy7x9uneJyuQ=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.21.1"
      "sha256-Dc9odZHlmMN7XI6yRd0N79ouMlvE8GrxjEewvSbDPSg=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.21.1"
      "sha256-WWnWuzaJ6+t7eqFu40j/JrGBgS0qkM6ScQdE6Mqfi2I=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.21.1"
      "sha256-jvLlHO4zEnPvthT4PskbrvyM5sgrp7UiTo11e6DYSX4=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.21.1"
      "sha256-dsIkq9VprfElRVxzevgbJRGVM7f8VOxb7kfRcHTKWMI=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.21.1"
      "sha256-sjkZf8bED1lBtUUGbHTmGpTxa8QIjyb0wLgHCGd7n3M=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.21.1"
      "sha256-BC0yjOOV1yxAO3ozUqS3dYxm1hfHuzUg2O/YoMXICYY=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.21.1"
      "sha256-vorexzLmVCrQVJIVDVEscmnLPho80wmdC3mNh8kN1SQ=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.21.1"
      "sha256-uBXCa5lfu5flKBGMtgj/z9AK7LS/4EvDxOWG8/cW+A4=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.21.1"
      "sha256-xWyo6WTs/bdrYXfO92dR5+MvWTzUlPjiC2ZMy4prvnw=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.21.1"
      "sha256-8+scLcsHVt/JaKVk8KPaCktmwJjLS9Fum/e8JFW6jKE=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.21.1"
      "sha256-OGpTK5ZAueYJTzA9H/i/8XiYPmXlu9T3E+aIz6VKRIk=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.21.1"
      "sha256-v4vvxUt2VepV4dHUcD56lL46yZF7WJGOTXiaVw654hc=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.21.1"
      "sha256-Z2gebT4VdwcEr8qDy7Sx2CHL4kQyY+DGvRqCJrR7uqU=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.21.1"
      "sha256-0CzHCf1PWf0CiYJdRR4eahWvOwePqcLYvGgca68lgJ8=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.21.1"
      "sha256-xQetSmeV1/59o3XFfGzdDmzJqq/PYO7e59k1g0fpMCE=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.21.1"
      "sha256-0kJIzPoskwEHtYn1IVmjeClzXG08nm7bUVr7EDCkSW8=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.21.1"
      "sha256-xyr05kq53nVrDA49ftQN2rBD6eBNRI0Zks8pKxVGRpw=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.21.1"
      "sha256-p0CXlZVmjrC865ddl9btMl8FUfvDyTihCp0WhTSiu28=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.21.1"
      "sha256-6JjR5E8qEYZkyuWKuo90iABFK2gxJuEX950y1P4gDzk=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.21.1"
      "sha256-NRBdipQTYgQow+8xDTU7q5l2xyveazp3sXhufQL0Mvo=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.21.1"
      "sha256-RPgRlA6dk/3YUdVv+IbzpzHxz24ScSXQq4a/lgRoYJI=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.21.1"
      "sha256-jV0ZML5vJsJf5dn7NVEHVq/L8MXy3VqPk0fQtXLfXFg=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.21.1"
      "sha256-X80EllJUS7Ofyiw/d3zbTxps5/uVVr6+3I753iChdX4=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.21.1"
      "sha256-N2LuJLtdyG4osjcKgjqVqY5OA7U35SNdhp97fN81JN4=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.21.1"
      "sha256-+P2+cHwVuFLRGiE2vSHJJhBHpKk+mEXo1BGqXR+Vy3A=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.21.1"
      "sha256-iQPHE8qpDPjnomAqY9ECnrlVRMikHBzDdp03d96RSdk=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.21.1"
      "sha256-TrC52x6d65NoOzcqycZ+SLwoKSqrWGMDOcvJCQTK4DE=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.21.1"
      "sha256-Io8j4lKY+ybspLyl95dpKofAvxkDxoZpcg4w9gRIplQ=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.21.1"
      "sha256-fJWBxIGVqI0QM5RFtpdAH2XUZ4hjqI6C0POn8Xba3xg=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.21.1"
      "sha256-C4CiyGwUTETxgBwQTJpcZlOUjZaGdfYjl5wKmGTW3yI=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.21.1"
      "sha256-aZwMCpF+C3Bhzmb8k7YBoSJEZyF/sMOd4cpVA9Rz2OU=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.21.1"
      "sha256-GFIKAax/SjJgqbOMQxmkuoJNaeEmlWxbNrr0fgW2ivE=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.21.1"
      "sha256-legUgBGA9FQkivTJvoz67BFRhOJ6GjPAogk1BVAwn9o=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.21.1"
      "sha256-E7ON9O/lHVZ63T1Cj4rpvmGyGQ6zarkPQ/sSAHUw4EY=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.21.1"
      "sha256-jAZN7P0yw4qaMwlOmWn8k5re6+ywQPeSpk4gbzBnWlc=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.21.1"
      "sha256-ng/7ZF6yAxpLdHb3rKzQpmVclvakdbNxegIYpWABzVk=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.21.1"
      "sha256-zfN2zKAokSGgcdcm/6xvkblo7Jn4ZzKWhjpQjURizhI=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.21.1"
      "sha256-uXDFlvK3uSXAe5n6piOInL+Tox3Gahg5+gxqc8tMI24=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.21.1"
      "sha256-dDpw3bL6MuhMdicTvuNTSBrbY4wl1DdD0IhAnPyQHIM=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.21.1"
      "sha256-mue0yyBNMtj94U+3DYjzexb5Xii4hXak9Kl06vxU2CA=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.21.1"
      "sha256-J4MVuZiU1pZimtJfQLnMC9kaYQ6ntmqbnwr+T5veMD0=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.21.1"
      "sha256-lXDbgHzuo+rlaX7kKUrSgmDY+3563oTTmSmT3GIVBXM=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.21.1"
      "sha256-IaSFd4QggalwxUmYMUIIyoPi5AgrHTppkyWagQx0Evc=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.21.1"
      "sha256-GXeRcSVy1YBDvCLexWW3wFpS1nJOwruD4LDI3khCgTA=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.21.1"
      "sha256-vi5RL+LyKHbnSHJCboJftEMefhsOVjd4mlsM4Af5YxI=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.21.1"
      "sha256-Oezadw8MPk0IB8wAFuvSC7nXJdv0+7OwICm9MKNYw+Q=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.21.1"
      "sha256-LUUnpbpcksDb5jjNAgs3ceIUPTVW/BPbp/pTVlQwBh0=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.21.1"
      "sha256-4aCsDoag0PsizSrEnM7Z9s/Up+97D35qDddv2kT5ipw=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.21.1"
      "sha256-zJhpmc0LxEK9KElX9eYaN7NOrW3LqDdnN+rMTBpH0ck=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.21.1"
      "sha256-u2XTZsarw3iCzhnfX5pzPPexHDDndSxnsvBKnIxnwt8=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.21.1"
      "sha256-Hs0gRB2haKdbjq2x0N9VF0OVtpyj3wLwn5AInZrbRY0=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.21.1"
      "sha256-iEDRPNI+j1kMnwmEqofGeNpXMPmNZODksNHTCOSE3m4=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.21.1"
      "sha256-tgwvN1JvZ2EGj48dHkzyNOkQLKqX9GYvg7VECd4TxXo=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.21.1"
      "sha256-RsWEdwv+/16XSAzmz/ZuQ//JI1pN9w0CrYFE9JxKA8Q=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.21.1"
      "sha256-VfYntBM8k3pWYcMiOk9tUaq/na20VsAp7UlkLOy1KHE=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.21.1"
      "sha256-4uGgRRMmYuPvNO+BiEYaLWdL//gd3ANZiaWiyp941x4=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.21.1"
      "sha256-ToEuikquETcHv5zt0W9wunSTe+d5DNpHiqFBsVaHb+M=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.21.1"
      "sha256-FDldCYfdWsDrk6jAV34nejZ78bUmYqNRhVSgLsZWW0w=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.21.1"
      "sha256-0Kjk8PbeSB4jP9Ty6UQGOw8stgU56QDykgX0sDjrnZQ=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.21.1"
      "sha256-ukpFDviAJw/9DzLgjEfFwmxYgFQ8QTwb3IoLSRDlWpk=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.21.1"
      "sha256-tAk1V/6EM/lRJzXmisK7qVRu8LfnMA5WGmv7l04vCa8=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.21.1"
      "sha256-ftbRURPuE6XWDfIrpzErRmFwtrG4z8+lnFo2quOdNSk=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.21.1"
      "sha256-ErRxfxH0rRukUrW1jcI/qUtbSEpU1Z+qtpfWQ+iOFjg=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.21.1"
      "sha256-5xzAt/Fo4po0j+Q0m1OYk+GuNuWmUI4LSm94wNTQbIY=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.21.1"
      "sha256-Biy7jR5k9jFdgss4N5HqU2J3jXN7mqhDEJmMjYe81d4=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.21.1"
      "sha256-fOOh3r6ezrrxdSWDsB1JlW9b2zvAXCoVnBSB/zIXct0=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.21.1"
      "sha256-oGz7Mrk87tZ01be4EmILSIi0kEiA6z+zy+ei3DkR97o=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.21.1"
      "sha256-kkuduYQEauPKc5Upni9+ciXzTC63BFhkN2aHbrjrQBM=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.21.1"
      "sha256-0fi3l0zlf9z8KrApDtRdW+iKEikULbNuRbEv2Kusrzk=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.21.1"
      "sha256-01o85d3OD79Y6+o8CokhRnrsWxtC+S19Qj4haT1ICtk=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.21.1"
      "sha256-iiDBUwCHwKyqRz0/07QvgF1N+DGxogz95xFmex97hFg=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.21.1"
      "sha256-AgLdpfdAbUJAkkcd2rwvZYWIEtbIAYNwqKXwLACLNSQ=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.21.1"
      "sha256-pjkfRpqmP1wM2F0EgotU5HcbF+dm6nQWSaqTGYMLjvM=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.21.1"
      "sha256-2XpmdPtvjmrkN+Rd//ea3du07/UblScMKd/pMz5qkOU=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.21.1"
      "sha256-38oAQ5sisJLzUVJCD/MzUvE4EXtWTfezCeyI/AqvxBk=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.21.1"
      "sha256-1pbU/WCMh/Y3Z1mSWyhyoOQUOJJG1W/bNu+jMx9tRZc=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.21.1"
      "sha256-qKQCSEIDch2//ng/jPKM4O/iRuUCaXEKEGwuJ1xYOnk=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.21.1"
      "sha256-4yvMIIzs5krOs3TrYGg4RP4nyY3sPI2P4vF5Dd17TOQ=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.21.1"
      "sha256-ezhX7eM6sXOsQLTo4I0MT0AnXSHuPFBo0qm4/E140sk=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.21.1"
      "sha256-1Zwq3hG4sN8O0M3qzvUNxzA3VowGoa/uzWJp24X32gU=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.21.1"
      "sha256-jlibP6zV/oLEEMPPTftvYKkH0ueWLCuOpHLJO8tLns0=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.21.1"
      "sha256-kwlD/RI27GT0Xtyy5DuhwIx3xcso5f6/068zenlswaE=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.21.1"
      "sha256-qdQnMioXWOsjNLaRD2dByR+9aAd6oAGutiMrSxMV5Qg=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.21.1"
      "sha256-rQHphWMGP+1bfuP6hH7ERWi0LxJG5OQfhLe/tqAR2Eo=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.21.1"
      "sha256-Udd6RfzqYCsQR/+rZil5Kyz1w676VPWsRMOuv3eustM=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.21.1"
      "sha256-oE7ed9qnuxvH3rSPtjQG3i8Fspw96wVdRlcNHpJvxx4=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.21.1"
      "sha256-6cocEDixJddPKNaxxnEz90T8QVLiJ1pSjzvzhP5C8MA=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.21.1"
      "sha256-8jIJ/MjQwcnUnuLwf1CXgc4CBmnQlXCx3Dl46PYfyDA=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.21.1"
      "sha256-vrhaSsGIYve6ENi3LnDkPWWZJyJxOoclolxLpFOTaw8=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.21.1"
      "sha256-ducEq9BLAYi/6twFGfVYrOgViHzrSAHOD7HviBPsmlE=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.21.1"
      "sha256-6wIJyWeLXQ1NwTNTeuIphDK6T6+NzKe4yrrY5cJ91i4=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.21.1"
      "sha256-mR4MFAqKAgDs6AE7ZdVsgmfsF6fqhZATeWqRe0Q+Uts=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.21.1"
      "sha256-mmTP8QiIrSaPycPfny2yL2QCOmpT04qxzAU0J/5RPkY=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.21.1"
      "sha256-MANX++Hu+uzKtE0f1+xRua4NF8dkFD632pPsfvrsojU=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.21.1"
      "sha256-nYbVqcFuSxu0nuBBOSXsaTzLErApGuJF+2NjP6SNO8s=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.21.1"
      "sha256-dzpOTGGtaSFMm5HnfXdZt3ad1T7TBWcFT32S5b6OvHY=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.21.1"
      "sha256-Ma5/djwfTmIAdcgPJZF2ag0bYJcRdjzaYqtoGgG+Gsk=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.21.1"
      "sha256-JnurPzXwhMQvHN7kz09MXNE4I8HCweuIr3SXsxwAMTk=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.21.1"
      "sha256-l7dQCqAlELjkHyqBAZMIS15xbjUlmGLR4KQsFUAbqc0=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.21.1"
      "sha256-Ozk1N8H/oU5xRhlgzb/pCCk+pOohQ1CAj/6bYfI+uUU=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.21.1"
      "sha256-0act/jKOXcMHNUCmFJFqZadaYTa8lBGqHqN1b1QwHVU=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.21.1"
      "sha256-emU8snPTKIVx5wYwQZ1bol0Xc1EhxA+3JiPqNInOSCU=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.21.1"
      "sha256-nieCWlLOxfGBkOG7QsFQSpKSnSAkWm7YpEWkd85JInQ=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.21.1"
      "sha256-qnc31balMAQEOEf2zDPOn0D2JVtkTU/c3OWOlQpHn5I=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.21.1"
      "sha256-Bex96kGNRkbojHLpxUZh+NmSvzPXNVcrQ41+RccDx10=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.21.1"
      "sha256-AxQ+EVO6u707Vx3fFyKAodDnqE/MXR1jP7RDwKtBqJw=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.21.1"
      "sha256-Bbbcb3cqNVB1+P/d0U6VO7sFEOGdqRIJaDAimvgcBEQ=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.21.1"
      "sha256-4eLcbGCrJQY7VkokXNS6lUqFED3EbxSwDoN7yMpmLSQ=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.21.1"
      "sha256-zZnp085zew+JtYjdngkzYwL8jCo6tgQ8Aw6InbfzFtw=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.21.1"
      "sha256-atZDytwHmi/VfZLKjPpRASQGF0j4wx8IP0Qm/JvjZxA=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.21.1"
      "sha256-baORJluJH7Vf8EkyvI8k1lK4Hn/BY7pZLrZtnMgdkIY=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.21.1"
      "sha256-MxnlzAJWqaemGdoJF3aq0v1sLjqL11F9GBRx9oA1/Z0=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.21.1"
      "sha256-uye/2qtf35DvFj2V0HKvVM3SMW5OTZum4srxFbClHcc=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.21.1"
      "sha256-pTckQhZbqdcqI0ob5m4GPGsVka3NfhOuX8Xh8LrstWA=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.21.1"
      "sha256-DSU9OoyNYk19zjNb9cXzNu5cN143x6hF6lzTZgjKzog=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.21.1"
      "sha256-6+f8Coecn0FIoExmYmqI5SyOBUsXdtgTf29A+7Z4Ilk=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.21.1"
      "sha256-yz9l/tAl5RKZFcZjdZEzu+URm+Fv87lCU2gFRKKDh2M=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.21.1"
      "sha256-gjG0KoWCQDiM7am/bBH7zSm3h0OtlvgPad8qOdOtSe0=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.21.1"
      "sha256-0+hA35qgYcaj7JQM8LTQRrwozOHHbfnTNzj55C8wuUA=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.21.1"
      "sha256-U8AsAvpmtBIPS/NvG5GryC4amerRBN46uN8zou7oEWU=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.21.1"
      "sha256-ghetqRtzt6Kk4ZYKE07RtdpPrt9YiqSC8ObvbIKJoBI=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.21.1"
      "sha256-YSn1ozFQ6dARonJgWNWm+aaSuiRdysQ1ukGhULOTBAI=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.21.1"
      "sha256-hIcyNLAsJbquvwKVCU1quQfiBhMJoIWO6LleYbfRV94=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.21.1"
      "sha256-QAuchxKbc2ibrfL297VSF62tXGhmiKUWxw8XWvt/TXs=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.21.1"
      "sha256-fq3W23W4DIEspJwiPyENK5NK+Bah11aymj1KklfYTx8=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.21.1"
      "sha256-0Uzj5+uuB7HLyjR80ZItfUICVgg8JDFgkPRdU/IEzso=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.21.1"
      "sha256-5xHrf7aAP674HZysEApXKeoM9X3QIm/QE07HTMYpkOA=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.21.1"
      "sha256-kFP7CdmP/icEAadod5cADBzyVDSrz3ovmxXH3ETbzhk=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.21.1"
      "sha256-fXCD9ADVQzvtQ0DqW/bXLYvPoNH9huMQolp34T8XZVM=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.21.1"
      "sha256-JaadKeAMSnOCswQCbFOei4bf/c2lpry3bBSRXW4ztYQ=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.21.1"
      "sha256-XL7Qz5GOzycX/Q9EhtEc+3QdRUYQFObQRdQGQT/XKR4=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.21.1"
      "sha256-4cznCXPK+j+hjDtdV/zAydYT3LYFgSyPYGqnD1bjb14=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.21.1"
      "sha256-5wr17LvIfMk3IQ0+YEoMfMpnIHKgLUcQdSOmFLGLH+M=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.21.1"
      "sha256-u1Omk78SW1udgLzLF5Wbik84AY1JY8yYQFvXG6K9CvI=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.21.1"
      "sha256-EwM9FhKpX2AZk+YrUy2es3rl5ugrFNjg0pqrE8OEmSU=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.21.1"
      "sha256-jKxYTPzp2WKUCQFPrXei/A1rm4FkFpcPgUYPcMXzQOs=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.21.1"
      "sha256-GFCVjAXOpEZnIcsT+ZVAXEh5aXZjVGqHapeZ11sdAok=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.21.1"
      "sha256-dZ6YW+AuhRxFi5sQVtvF8VEmTHwLssCfLdh90bZ0POU=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.21.1"
      "sha256-Rxh69QCmI9dTCkFJQ/l09Ux7fKreDUfqgymMozm04vc=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.21.1"
      "sha256-k8fzhT6XxDy2Pm87XqJLsqaxE3cvAjPJCX6J77/YR68=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.21.1"
      "sha256-tUp6HgR4g2gsr8s0rSyoWsgFVRfWRgz9NwH+z+Xukok=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.21.1"
      "sha256-AajKZ2L4JIE1ESHhLLkcF1QKlDOH9hLt37oQOab0bnk=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.21.1"
      "sha256-+ZhOCv+OeTutxjUTOZ2IqiCmLdX9mCmCVNfKBGTWcaI=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.21.1"
      "sha256-6zmSzVIMb4Z6+GniyFvYurSWrpwFUL5XH5FsRq8/hwU=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.21.1"
      "sha256-+Vc5RHUcUkww59PbyeacqVhox3BXuKm7t3IioCcA4b8=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.21.1"
      "sha256-ihF3dxzd4QS6Y3GeO/JnyLLt24fV23kYMMcrQ/Gv80Q=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.21.1"
      "sha256-scHecaB1/O9OJIPglRZgx7KxICNHqNLvUj3oECgw8Uc=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.21.1"
      "sha256-1Jy3qNwTCMdEvSQR56mfaScriqDbG2u05v/JjPRi3iA=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.21.1"
      "sha256-vwikOUgvX78vuTgpxiuwRYDEx/7fNfi5bnEtS76nN5s=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.21.1"
      "sha256-oJIw31RA54L6waHjMxYw2HpKXGnPXy+ZBZca2qDaGoc=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.21.1"
      "sha256-rWSakkkcZWoG+aaDypSdKEIUvSIgZ7U1yUIhfF13sQk=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.21.1"
      "sha256-x/iKYXCCTRHsu/gfN1I/+WvXqF+WSpkcleSvl6eTJz4=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.21.1"
      "sha256-25xz/i9GbM7pKMVpwSi1c7fTZ1/JrPQVgxke7ghqZto=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.21.1"
      "sha256-j4fqVKd1+2OUp3IIhG4RNS9VYGq6mmAR++Xy76zPSwg=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.21.1"
      "sha256-Mjk0gafy/WG4KLP51HCzfJ782Ovtd6igQ86/nLP8djA=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.21.1"
      "sha256-iA+EuPPGVf9G93uUa6xwwWmaTti0JmdSQcnVWzIh5/U=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.21.1"
      "sha256-+Mu1FSvoUPZZcrkty0DaGrW4kSqKUlm/6/s3daUcLfE=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.21.1"
      "sha256-Av43Dpj6kNU0Ogq1EszYJ9XWwJLDnIxUvZWtfWOt4lQ=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.21.1"
      "sha256-i/GMCA6l5TeE6+LF2LEdLfW5dzq11evZE571VI6dm74=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.21.1"
      "sha256-aP10RmpNblRq6XVAzYN4eViV6k/OKjbkkOtuzLxAcvE=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.21.1"
      "sha256-q1RNWuU+RDCFeAnebsZR/ycl5ZhhmQNaqmfeeER8eQ8=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.21.1"
      "sha256-9e5eCP1J4VgHwN9y9WlTuGlcDGsy4nj1yfGqs2rw5wc=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.21.1"
      "sha256-cGrXaPN/F/+0hjep2VSDLirNfnK05rK0X1MXk9ch0BA=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.21.1"
      "sha256-cotOndoLNkSa06SlnkE60WktWkY2MwXBXWx1/eK18cQ=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.21.1"
      "sha256-LM5hdcgRP7T3om3UPJU4wGI6Av7BMFJJPcAmWF/cuLw=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.21.1"
      "sha256-SNQdQWLs4q9RvW9+1IIOIPETnJpMY/T8zCkD9y0wzZo=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.21.1"
      "sha256-D63SAfJzVLJFH4xbzcpSle7jj01S4d5EaAo8lkokUEc=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.21.1"
      "sha256-GDdxTxMDHz/LpHJI6xWmL964mNm9Mr3wbTXPPHnDlT4=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.21.1"
      "sha256-2UQbuyY6a2TN4llwqa5PKGXVC1tOHdCb/I5RZJZhjBQ=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.21.1"
      "sha256-In0tCThe3Vc39fVhchCgmWB4vqARAW2y/TRBdmvEnWU=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.21.1"
      "sha256-w/xY8x+LadL8jO9dVUnkxA5Tq5nM8rWL7EjTkzRlVKI=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.21.1"
      "sha256-9+z9foaKUv7GZpMZN3DGq3vRNwCYqk3pjr/DeM8WndQ=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.21.1"
      "sha256-Mwwnih2TEGahT3iYvDtVdvQjiiM3jeG2x60A6RRhG7w=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.21.1"
      "sha256-smQuIqpkBKArpp1rvcsW/M5mTzv/YWGNWOndwmMdiuY=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.21.1"
      "sha256-nou41Ra8g3Nb+j0hX7UDecMz6MSV+LK1nyUZNwYfEXg=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.21.1"
      "sha256-eHP5VvTMHyz3SPF4bfpL1oLqSsDkxGPMFe1tkT/WL4g=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.21.1"
      "sha256-QMYx9PwFDZRKkqwJdhB6YGfZKn8iJXGEKM2VZPhX5Eg=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.21.1"
      "sha256-LewTLT1sjyPbtxXy9hUSt/Uh9DAKsUGgh2NKQeKZvXI=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.21.1"
      "sha256-pSF3kuurh2G2IXQa7NvUPL+KaCugfjdVh32n/BmtJbI=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.21.1"
      "sha256-EE9ZG4MsVJP6IMYI7U/2M2CFxFnxT8vhMnNEpNgpgss=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.21.1"
      "sha256-+CpJKLF9jzNVspi/hXSBpRCssS80VLXvQgqFblmXjco=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.21.1"
      "sha256-pETkpRbtmYaug5/HMXlqzqU/TXg9TZ+jMAoQU/4wH/M=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.21.1"
      "sha256-2DeLQKW2aKEMkEf0XTBlTMiizJ1+5F0jF1cCf63hF00=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.21.1"
      "sha256-bg/4s/oe+rhs6F/iSdKvt8ZplyEMRdzPv2XDfu1PiaM=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.21.1"
      "sha256-qLc6xSJr4C37jdRL6pMhODfSNhJ/x/llcZWAU5JyWE8=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.21.1"
      "sha256-V25RWD6nAl2ryaPGFeN6gmJIadLBmDB6C4KpnHXVuZ8=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.21.1"
      "sha256-BpgHhCLkEkrxucw3MHRSv7ErTuKaKU6T2U/yykdJdJo=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.21.1"
      "sha256-XIpot41XcAYGLeTBWL2QLqssOOgVcL5brAInN1+dgVM=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.21.1"
      "sha256-68FrZsPWq37JlcARThvx33uvcogmHcwuexNRyuurmjM=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.21.1"
      "sha256-eYU/XyIeONMv19nGZsmGprRTOwuSj0BuIpEUILz4FtI=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.21.1"
      "sha256-NAKUN8mU2fctkGJ9mqzcaehl4sACPgTU03qHNYXTLqE=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.21.1"
      "sha256-xud9xRPyI9n0irHvC/sJiprmOiKv5YrYFiVgPCc5WBU=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.21.1"
      "sha256-xSYxROixgWrSKLHjPaDQu9aYWT6WDzGJw9WA63oBoqg=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.21.1"
      "sha256-osAsPYbEFFDGK5p335aeSVMjC4Y+KuJZn4VGCgf/VCA=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.21.1"
      "sha256-fztK41WzSpOq3Uz3vVotdKRdkjjiNaGyEDDhsFsgpjM=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.21.1"
      "sha256-uR0Fg7pC5sMkLtk4HJPsK70XeQ8GjfG0jjMfd5b7lMI=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.21.1"
      "sha256-MPFbNMuH+t6+BpRDd93iLTJDZQvLwagH2hD9GpIEuU8=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.21.1"
      "sha256-dzWtfI/YLlFd4Jy6CtotSKYlexq68wfU2eLkm4r7iFA=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.21.1"
      "sha256-/8WbXAnCCXUyqcRMXsut0F6WCJtWmTZOlyVMrx3HCVQ=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.21.1"
      "sha256-dVxlgbf5Ew9mK11BMkjP2ip/6shLjHiFHyR2gxQwid4=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.21.1"
      "sha256-gABMloLVPVldmcojXnVXoJ/GOnpOxcANN/tudNzu464=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.21.1"
      "sha256-/EKXhroeRImqCAWQsDcNKVhHLxtRF27R/yrft0avcW8=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.21.1"
      "sha256-CBq7nAuszYSmCHd9MHdqWDlD0q/9ObCck1IKOTM31zo=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.21.1"
      "sha256-NwHKkecULbqOdP+4Iu5VjEZqrXwqO+TKCymAtVyx0hE=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.21.1"
      "sha256-/CyheL+gXWPEk8O6BQquAKajoWo18oOeeMu+ZZT5UtQ=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.21.1"
      "sha256-3I4OVwM9DjSkdBt3Rbb2Ml8xTMBAuRrsmtQFy/ALPNI=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.21.1"
      "sha256-P3uopoHs/kPdU8cXR9wHkvph9KXgOyLk9jdpE4xo6dQ=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.21.1"
      "sha256-1ivJWO2/uPo5RDla2ILzC4qCGp3qq1rtr/9f4EC2Imo=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.21.1"
      "sha256-ZFg9sUxNBmY1/Lydd2QSaWtoYjdFH++0N9bUXTnCTG4=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.21.1"
      "sha256-JV6vbObS/5MeNrOQjggApbIjGZpQqBZwG+Luw7fdP+s=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.21.1"
      "sha256-6C9/aQ5pnrz0T0+BQssHqGuAzhah6kHueeZaclpfN0o=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.21.1"
      "sha256-8JFq5ZaWWPdlfnvet1l2VgNE8C1HtLfcVrqqp2soFE0=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.21.1"
      "sha256-eEm0YSuKvwWJx53HBX29vCZR00gT6ktoX60WXKqKezM=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.21.1"
      "sha256-F8pyO/ADTTUtPUSuBroJBE7FEKdhn1hhA+PtBBuHnCY=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.21.1"
      "sha256-LW1CBdzINUfWbf0m5W6QKwp2Enculo7MXn2/C15lGc8=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.21.1"
      "sha256-q9/bl4Po1yi7WVToMn299a4lNaVIsas6KUz2DwWa3Pk=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.21.1"
      "sha256-3Au4XAIJR3vlVhANkVJNo3iKSC0YPrHOxdElAoGAXnw=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.21.1"
      "sha256-ic6Ryhg/zI9aml+Y4if8VgpXMkRYvKhaUTsZJw4HaDg=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.21.1"
      "sha256-ChPJlunIZqh+zn0da++rpGhk6B8PifrXGvZLyR1+K0M=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.21.1"
      "sha256-GANkxO/QXGBJjDKUKX6LNZVZWYssUftqRJF49WNPjhg=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.21.1"
      "sha256-/Jzzl9C8kKS+sUgd+oUPoWTIQHyV17CYB3eqWDIdxMI=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.21.1"
      "sha256-IKrRCAOXXsotc5gTxYFeFdJUpbLSbuyXPB+12S4HsXo=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.21.1"
      "sha256-j9AqcvFAg+oWTj8TI3AlyU43E8BmsWxwnBhor8pk7Qw=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.21.1"
      "sha256-0WENxbDD4KsbvKb9X0CQBmf5/7c9ut/Zos7ZTzl5FiM=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.21.1"
      "sha256-XytTYiwUK3qIR8WGKBWGTGbNmlEJk8EaQLfP1KDFPUU=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.21.1"
      "sha256-ua+mgrO1QPunq5FqKDdHUI0xgjG6jTB8W9arWXAFJNI=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.21.1"
      "sha256-9jRA0s3OsLXVsE+ugNSDOU2/XVXa0BULPsSAd4z/L6c=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.21.1"
      "sha256-Ha6sKVRxcYTt+v/Flvu43uTZdDgxy2xj25ZvIFOOOrs=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.21.1"
      "sha256-c8SequNsyOf5AagBvnKhioh53j/NUN8EZrZQeKtT/X0=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.21.1"
      "sha256-SxhwiUC/Mxsn/Ju3VEYmDxA2+Ds7XD9BWUkcv8w619Y=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.21.1"
      "sha256-YNeOy350GlrNuBf9cgr86XqMgNmMMQz6+SeAkrhRetg=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.21.1"
      "sha256-O7PqUuyxBV7c6t6nG2dO51cvzyS8YzMY+GJuzfskQlY=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.21.1"
      "sha256-xLMsYO7d7g/dAerLI13tYFeyWM3+vDjwt/bZPKmOU+Q=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.21.1"
      "sha256-3Ts6XMTYh1t+1spOsKFc+2Ty+CgjU1hf1MLpkRawT4o=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.21.1"
      "sha256-rG94PvosII5vSSiPtqLfEEICYuHOrmTbtAKxluBv49c=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.21.1"
      "sha256-5H0ykvwgiCEFk648y9+R4GZzIrbTt673Ah8bO2ZATPY=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.21.1"
      "sha256-uiVS4Lcz1AyV3jjgOG0+eXQ62lzCU4XBMWbfuo/I1z0=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.21.1"
      "sha256-LjtbWZB593pARCrLZtgLJ+huZvIlsWscFyxgrKmXTgA=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.21.1"
      "sha256-ggadcURfyVQsJ5ZmVbaUStfZBAuvKbDdY83wgFDh7YY=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.21.1"
      "sha256-9MA38ye2mdU/WlruuvPPVfe6rtCx1OmCW0dwXqGBec0=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.21.1"
      "sha256-FLUf/AmqS3h1zPH/xwfftD0h1R7D7Zt0oQvwIxwkONk=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.21.1"
      "sha256-3CUJLa4wMLt6BHNCDN8nWOhqCdqhp6f3r7e4vtnkzWo=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.21.1"
      "sha256-DTpkdq9DChWj1GRfPqeXL6Wo1Raez8I3iW/Zre+6Qm8=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.21.1"
      "sha256-oMtLqgXyZ3S4wiB7RY4c4Lptv1JAG6JakrqHVeplP7g=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.21.1"
      "sha256-gmaDJPODjXo1wXxGXcK2jpoxFs1h7+iTuiiqTwDLQX8=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.21.1"
      "sha256-/O/2l+50xS9wTUBwHJ3lGM/C0v4Bhvkr0CcqIv9dgvU=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.21.1"
      "sha256-YH3TIJt7yA+rQ74LgDSysswdR+nGVKK+E3Uhgu1Emr4=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.21.1"
      "sha256-4yp8wAwBl3CHZLiDMQih9aGCCQLD1BAju12lIpK3KAo=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.21.1"
      "sha256-iYsAE2K2CytHKyedu/mVwKJeynG2ytsN//XKUBK28v0=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.21.1"
      "sha256-4Y0qLH58cNA5MvG8DdZGKjhLeynHCjonW3bVNRmJujU=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.21.1"
      "sha256-flzySNSyg/HR3VGr8HtfWDV3rXWRiFdbPfAMp7o9DXQ=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.21.1"
      "sha256-3M8tvzhdnEsxZSX8FiVWWRmRklFeWIr67gKlbWmShpE=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.21.1"
      "sha256-INoYqyGasspIfEObn4MqFOGVmyLEMZwlum0ydIhwSBk=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.21.1"
      "sha256-xgJ7nsWkrAGddUriV1o5qjQA4I/G8+Ee+NBffHf+7cw=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.21.1"
      "sha256-yRl+vEP2xD3bt2VJbUljknEktX47e8VIY35p6JXSVu8=";
}
