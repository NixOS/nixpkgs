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
      ]
      ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

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
    buildTypesAiobotocorePackage "accessanalyzer" "2.25.1"
      "sha256-pMf7hKCKrl3MRRxugI7uLwA8jCnVUUW/8rFKD8fnuLw=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.25.1"
      "sha256-NrlheHJhq7vLK/6WfIX1/FAsfdJBd9PDsH7VabzpE4s=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.25.1"
      "sha256-h3fi1vZkjNPaTmsWrDbfRHBzHwuA0CuaEua4yqnaIwI=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.25.1"
      "sha256-ydvC2o0RHJ60kQ7hF2K8cGa9VDyWxTTYLz7bA0bWanw=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.25.1"
      "sha256-u00hvOdYiQ+vG8AdRTzq5G9nZTP6H0SlcXtMzTNxf3s=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.25.1"
      "sha256-Sn9pLDv7/Q2xuvaTHmU2mC3aRc5M2KfgNDWJ9Ywjkw0=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.25.1"
      "sha256-23aPaq7yZ9O2TAPUug9LuQKceS27Hfvy0RbuZGtMsoQ=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.25.1"
      "sha256-tU7YrUUAmhQTejakvWtRhnwsQzYfaBBqsJasCzr6yXU=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.25.1"
      "sha256-LiUzw6fVFux1bfk+uC9+lDYltb0SeQBBIeDHIH8r06M=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.25.1"
      "sha256-IuYIXBgxzmBx9ESWJzZfCff/+U6sAaXmUnR5rddzYOc=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.25.1"
      "sha256-3nFS7CIGrtbdemO3RrNm4C83KT2g73gkHQ2rQzgIUto=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.25.1"
      "sha256-FjqC6XNq5bAAXve4P59UBV2jNObnKSsE+5KQ0DBi0Fk=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.25.1"
      "sha256-a4mSCE+SGxA1aG2QW0ZX6Dws59vATbRARBJ9/GtR6yU=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.25.1"
      "sha256-LlynUDfbycY9CJZgzqXOdYd2ZMZ0/TLNQbdnrgIqomU=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.25.1"
      "sha256-QYVkBbjrtZYZ7oV8h8dCjxgMbzmmvH/WrQIOsD8AL7g=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.25.1"
      "sha256-VgBvQiZnRVMoJkrVqNukVyise5V58abDyr1NnqCqfKE=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.25.1"
      "sha256-oLfCSFpDDEval46hOzX2YcGsuc2bhAirj3fDe/yczTY=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.25.1"
      "sha256-9BAFQtXHFc6DckhQUVOdvWeKQyOoPa7NEhkOSXoumGY=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.25.1"
      "sha256-3dwAoxqJMIz7l8zCXzYu4+0sZNh+uy6V9ZDabSHNFSM=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.25.1"
      "sha256-zvOjVKnAAHhBz5FqYUHaQ7NIWm7qMJmiZxKRqtnwL8w=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.25.1"
      "sha256-ESvmAX+E5KIzfq/1K9WykdmZCgHalisSFj+hSvXrobw=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.25.1"
      "sha256-SofwNEbH+UNkuvVLf4xstUZuoCKXAlb/S5sDlegxPZo=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.25.1"
      "sha256-r6ohR0fJkJ+BSiagpBmGB5MSgDe+kSMRKG6+TMV9zVo=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.25.1"
      "sha256-mz6U/7XgHObleR+oIGuWkZboJpdTngoN6RfDpJj5R8U=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.25.1"
      "sha256-BTAzbChHrJbA6+1rKZRQW1+5MOAS/ggs9Ss7Mz2LPJ0=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.25.1"
      "sha256-m0zmqMtfrgV6qXRZ8f+JijZjxEQhAVLf4Cwn/vuP3D0=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.25.1"
      "sha256-GjxZLNJsmGKmDdEyUp+BgWOVVPMCcOTuS086K0ylJrE=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.25.1"
      "sha256-ygu9bCuR+5HPDtbvJH1WhgnT4/SwtXt1f4hXDA2DAwI=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.25.1"
      "sha256-JZ4D9JHea3ZRGXozfffb2uRXwIDVhTyUYNdnDhejW6g=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.25.1"
      "sha256-b6YRUDiAVpLnj3OYV5sg9HRVrOF4Y8hXkTxuKWqzs3w=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.25.1"
      "sha256-luTZN4zcbtETtUkdxgV97AQBeJPFRyU425yxSUb4RhI=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.25.1"
      "sha256-WUjkK78F2yyX4/NeYx3aGun/bycstgjbUlvlDlujXLo=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.25.1"
      "sha256-pvjnnRSL5E3NvhnGLcYP47AKmUUMfUtEafrj0Rp4ZuY=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.25.1"
      "sha256-b/BWtLpIbnTEtxaeKevuQXyWmB+brLHkWRKdINOSkBg=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.25.1"
      "sha256-YRwRTbM6hLZ1bhPqgXbyORysHylNZOFwHvHs9B+1yeQ=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.25.1"
      "sha256-PvXAg9TTWM7I6ou2XuFMgDGTLOmcT918lPlx54u5WaU=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.25.1"
      "sha256-L0R80FKwnDdLNwH6tBEv2pgUZY6RpKHsWddUwuaLPOg=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.25.1"
      "sha256-mkb2hWMWJpsaZXsh5rLfFxWz4TlKaKh6Ia/QPclVLXs=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.25.1"
      "sha256-0bWn+pHJC0xoDtttDvk1fWSojZnsUHulQwQ6hm0nXMw=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.25.1"
      "sha256-FFOQM66QQe5FL2TsNuWETlXqLZlpEwVBWmIfi5nA5MA=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.25.1"
      "sha256-3jI5Dpev1/FRvQaFRuK4YCwADvNhDZS0gKvfs6R44oQ=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.25.1"
      "sha256-Ng/Gms7t26ekVebxDjSYT1nL5cGMU5MdLmpjSGrbwZI=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.25.1"
      "sha256-DDKyv9XwaKMDhOfqCcdZQhucmx6MsUj7CdHWNMn/Y0E=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.25.1"
      "sha256-VM4XlicQ3/3WgQ4A7qZjW0FdwSMum3SrDC2/k5fd+u4=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.25.1"
      "sha256-aMYXOK9LAJDx+quW9Di0qQlrccnOiNEXbIQFQdx9c4Q=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.25.1"
      "sha256-QZ51v4CYjZ2q6CsEm8ZJxGVwMkHWy17UZ2SoCUksQ90=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.25.1"
      "sha256-yEWzYkAjRXYqddN/craJno5ubG8zeBznXPneQrff13I=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.25.1"
      "sha256-Ag/j5kEPq4pGhLA8R2YwYHlcKTsGmtAYsrTkVPPGrvA=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.25.1"
      "sha256-QQpvGaJYuT+R9PvOz+GKifdProjd+RjzSPd1UKD7ZVg=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.25.1"
      "sha256-m8eggf66DQ7NmOaSZlZLajwxABJJuYdTbMnjJK1dKIU=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.25.1"
      "sha256-COxi6Eskcw7NFi7+AX0pFDOBaVM7d/5atgqZXH4+9Z0=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.25.1"
      "sha256-XWPOUppk3BVuILfDd8lPfJYET/fX6cbJBE7OUDu54O8=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.25.1"
      "sha256-fmagIWKA6u8DyF2mXqUEnh/di9KrB4RQKqxr/lxGMUU=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.25.1"
      "sha256-HJ3i0DCZ148BWm8372pa85IYd39eRPSi3FN6+2V4uVs=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.25.1"
      "sha256-mLeFITDCRQntGeY2Pr96CzBlzzwEE0bB1zsFJCiGdPo=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.25.1"
      "sha256-ZQFHXzMteTmUiGwbOcUxyOkbRpKqPHExaHzAw1ea0oA=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.25.1"
      "sha256-kCxNxMjTyu81w27iX88VOR28IedCQPiLbk+JtUEaKnM=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.25.1"
      "sha256-GiIGF+GO8uG76xzlDS8QEG2ks01zp/YL4jsP9j+SVaI=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.25.1"
      "sha256-ygdqG0X99K+w/9VSyOu2kL/F+VGX1ohXdTJhYi/1qSw=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.25.1"
      "sha256-oiKSZ5Igp7u/pdttfIDVi1isycVR9D4bwsjJFHksCds=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.25.1"
      "sha256-lIbsSb76kkPaRG7BMWlpqlMIuStlrUqHUdKUD5YDjv0=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.25.1"
      "sha256-tLWNVtIHL8TOKfB7AIdpgDs1TWBA2CJPo9ASJM2fL20=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.25.1"
      "sha256-7MRqQmc25O/p7Vdd0S0VzKCi3WCCQom8DQa7h66cCfQ=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.25.1"
      "sha256-NUd+hoUI8NVzEC9GjNm8x3hl4VigVuPbqtL51R5NxQU=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.25.1"
      "sha256-tdFxJ+sotgAivk2EjPtfnZrItMefRzos3eyhGBKmf9A=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.25.1"
      "sha256-jVGkQ8M0+DGQM1ZagJRSz0RpW7Mf9JMDIsj39Iooo9k=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.25.1"
      "sha256-iVnoDEaLaSJh1+qKzU1cZPEm7oWIThQ8pqn31rOzroU=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.25.1"
      "sha256-vtp1UlB4IruJpPgoMzXYU3myJsInTle4poG5skwoECE=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.25.1"
      "sha256-O5fBqCBYjN8KVxM4JIPb2GRZWBGmSRh50GP6YVX3cxI=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.25.1"
      "sha256-iL2mwlvH/QWGYrfo5eSBrXwuD9dOeYERs4KnnVXq3Vc=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.25.1"
      "sha256-3cjSJXnoUABnSIha09JiKQ6KJc14y728sIUTj2bTmBg=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.25.1"
      "sha256-FDoimD6RmhEIHCfADM46I4Z2cDCMf9fa+rvqnk4LFpc=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.25.1"
      "sha256-cRoK6Qa+e6FirscAnrQrLNHLVw0nPi8cbNDbGC1TIC8=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.25.1"
      "sha256-pbRhq1ahJqC9SGGNvyKhgodH0QYr4xXgWbyXHorid40=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.25.1"
      "sha256-ubRcR3OrXySTq6YLCbyVx+h3ge3At8JFmlyU4uGiGoU=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.25.1"
      "sha256-WAsExzxO7tJdCYmeSDkIgGlMDtl8MLeRgTGwziS1q2Q=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.25.1"
      "sha256-zzNuF/MPygSrO+JEYK4E5djVC0OWcP91nzXdrxcnhEc=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.25.1"
      "sha256-LXMPOwrb4fBsek/Tkn7ytFH9ed4HRdSUZ5lPDWR11hk=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.25.1"
      "sha256-NZL4dZqjTEq8YAMLj2LPc3w2lPsA8bmeHELy0WQpbQw=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.25.1"
      "sha256-KMJdRLF+LwZBCrVSe/IFLfkEVSEcpJAiGy8aL6v1hPs=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.25.1"
      "sha256-ZOjiIHV4LK/tIb+TwKob+GUESDoGSmaUytmnDCQBVpc=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.25.1"
      "sha256-qbiVpy3Sf/MVJlVA/G6b80nxZP12DH5vwJ9h1BiOFVU=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.25.1"
      "sha256-RImEQAt0XMEaBoGCsFo0fPc/QI6Tn52fENZWc5hjei4=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.25.1"
      "sha256-AZ7ecgO9ydeP/DpTACSDVpBfO6SbObkFusCUW45kDLE=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.25.1"
      "sha256-/Fbdg7dBIr405gDlwnPf4I6cGFYUc+xYSVBtepdD+og=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.25.1"
      "sha256-ppqy3MzS5iReH3QeuK/9trxSD29XFc9Iaks7l5o7IWI=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.25.1"
      "sha256-pfBVL3751S7FesucixmUltCW5ysMoHWdFVlYyo61O+c=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.25.1"
      "sha256-0le2Rz9G51StrvMRhJ5BRyAI8xSLiGZNkJi2GV7Qq1U=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.25.1"
      "sha256-m+V/k7Xrh6vauxeAtbR2IxF5cyayArXx7HX4XUiNQkI=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.25.1"
      "sha256-AgwyYGJuP7COXNRHc2J0RUOXrhqn4AL6FygcwFosULc=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.25.1"
      "sha256-2MydYzp1s/WslaWOLpFCX7CZh3HOChscSlF1Rvf0W54=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.25.1"
      "sha256-F4EYJX0zMIyigb9IeOofLYknO9x8eMYkghcayJh9CT0=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.25.1"
      "sha256-hiMgd8uwenokK2rLmLTsL2t9Gf9AEh5zwl7ZWplmsEg=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.25.1"
      "sha256-QN9shKZxGJOLUEXQqj8hXMTLTEr1UrokfbMMpEEiCP4=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.25.1"
      "sha256-MtyU0mfNKhv4JKMc7tU537J5EBh3nSkJ9S6XE9PhVP4=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.25.1"
      "sha256-zIw7F5xlQuyvYONd/smlQblPIghx8dJx/Jp1bLEZmik=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.25.1"
      "sha256-teNsqR6E9MHuOTQ0BcZe91LGL3ACeBL+XkYg/kmObrE=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.25.1"
      "sha256-WTeRsXfwodBbd7S5EzNeVhfrMc7Fa9VXNI1HLJIXdXg=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.25.1"
      "sha256-/il4ZSLbU7h8hT1of3mGOi6xDmGRE+jdClHWXBVrTWY=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.25.1"
      "sha256-8UN28Xt4Tg0wXphHH7XHOzcOW3TMPRJdY8oWKBjuZN0=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.25.1"
      "sha256-l7GjTL4vhBekTzMbfXKL5uEpFGPTUNbXLx0eVN587HU=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.25.1"
      "sha256-MekJgC0s6pP83ouPqfItVTP1c6Bs5MnjfA0pLWaiYJk=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.25.1"
      "sha256-Y+rZaJoC7yjcak6RJ0Or5uxjRwEcHsAvRRbB9TxPaV8=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.25.1"
      "sha256-ZB0VYZUCX5VSvITicKqGi8mSJ2HTwmGyPCx2tWCYk9U=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.25.1"
      "sha256-w2fINiB7CbEIEaPXzgIsU5IE5IqmBS6RPfUjI7S0x2E=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.25.1"
      "sha256-2DYF0O+fJ5OC6IkZhFrm7qKFT4OX9OS02beCCJ+6E2A=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.25.1"
      "sha256-aHOjTSjW6DTiEz6yP423sQYGdQeB4kn9otn/E1R+Hv0=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.25.1"
      "sha256-kM2JAP9d889/w+NBy6CaYOaizwXod+h54prPNwzV5q4=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.1"
      "sha256-Ds9xTgBqqBsJtcgEn/6Tobmq7zh1aijQFTog/BUjbPQ=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.25.1"
      "sha256-PLXSbA80ViW1yXfJ72wg9QT9IOZmNZgYfjmqqgiXHmk=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.25.1"
      "sha256-IXPQ9uf3U3+12zLRw012SwQXd/IEBRD5xJhHm1z6Cc8=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.25.1"
      "sha256-VT2D7yolP7VjXSMiiY0Iyfz2nswdLNA8AXU2YktWBsU=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.25.1"
      "sha256-RCNZ+7tGGlpqSD11PO2LZ1rpaG5v7OHt1m9Tp+BxFho=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.25.1"
      "sha256-pf0XYupllHLkbG4RCMsDoCWjYXxhzCRneCxPqgTpdv0=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.25.1"
      "sha256-SQYZ7q9IR8Wb8eKcVLzHQiF6BZrRrrzGmcnj7Z+DnfQ=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.25.1"
      "sha256-5rsR0DjUEdJ5OJfOhFtoxouPLYS462FvsynL2QDzDG0=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.25.1"
      "sha256-cabvdIyHxNjdaj0dQ8CCQq+DoFFfHFN4IziblgYwxEQ=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.25.1"
      "sha256-vmYnXUjDWnet/5Ct1D3Yv6YAchOOGHkCaIdXnCDFX3M=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.25.1"
      "sha256-zgahm0k1C84fh95ptjidhEPw5eEWhLv9to/1dFiRPBA=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.25.1"
      "sha256-XrPXBKuNYWT5b6Pm7fDjbePlvQ75oewg3QY59VtRmbA=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.25.1"
      "sha256-Whm24y+Ke7GEduNpTeyqrD730DqVlKyAgttdqKZGjms=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.25.1"
      "sha256-Gqb0dUFjDN1HrqnpzpYMNynaiJodjtRVJqrg0hTxV4w=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.25.1"
      "sha256-NDvYv51GImqnOscZXytvgO2z7CmVmZK3v2od0iTswfw=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.25.1"
      "sha256-3gpCjo8El+NGeQEJ+48DHhEmDyq9lgxLUdaw6w4fKy0=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.25.1"
      "sha256-ihmh48cBKFjC8sp9rLU0CKCanTOFETt86CMvoHjHOuM=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.25.1"
      "sha256-iE8I+VRtN44OAlTnRoimXl0X/ZQLjsrvP+VP2MkAqXs=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.25.1"
      "sha256-MvIqZuVr3UBCNzT4J17QD4meDG3yXe+GsY58bN71sqo=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.25.1"
      "sha256-ODGJ7Dmt5eQ1lLbS8UOC9fTchMwmHoNj3/te0YKPzn0=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.25.1"
      "sha256-v4PcomqqABgRN4CoTC7oXBm48jEwW+Uh1isiyhB7a8g=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.25.1"
      "sha256-f14ruCUHfPSVWxWnpMvDxkvq+V344Vy+guOH5XBc/Zs=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.25.1"
      "sha256-nu0XNx6ZgJU6XBw4cISVqfuW7Fjdqg+ip20X6mNBT5A=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.25.1"
      "sha256-NlUOwigxEY47czNgVrBkXUGbC4Im4YHLnXnkF+0GTKE=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.25.1"
      "sha256-UJOGHdL0ffK5EQxbVXfFRdGhk8UId78dKxNDQTrvjlU=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.25.1"
      "sha256-6PdS9LsfF+e+KLLM8SKCgMo9payxN25gOxB77/vw9Qw=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.25.1"
      "sha256-aBFZniSBz+draLIP45cJbNbGByDdp536+ePyP5Sh+qQ=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.25.1"
      "sha256-3y+mwiRyGpLmJkkV/SmsziVxCgAoWnPW0GVqi9kdxCE=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.25.1"
      "sha256-IZUIDo/EVlzmHY6f7evtRvZqLcEacKAXoKnC7xvlcXk=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.25.1"
      "sha256-raz2M776ZuZdYcWqTkrWGfTMr9wOY3wdgbVxI/U5JSw=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.25.1"
      "sha256-kVin4vrKRyQ8HlNkyEL0cAJ/eyGw3L1yMTEtLktzDhI=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.25.1"
      "sha256-8M/Y4TilJMbTxgcmeNBshSm8ENhmF6hVwFRplAQRetE=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.25.1"
      "sha256-pXnb0N+50HysZULA0bKbTPfeHaW8AZHQvAfwKfJWbx4=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.25.1"
      "sha256-nXIV3ULJh2g/0crKh7bCDuof2/W4ek2YVi/dQWbNJr0=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.25.1"
      "sha256-EjwIzddKYCCR8br4dF/mrplZjVGZwZ/6XZjEH53/QVo=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.25.1"
      "sha256-ISW+Ezs/W6wBQ89/ltMFYPc7Xz8iALO8jZXVh1sYJWg=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.25.1"
      "sha256-0vQfu8Xvr7GVE101gzCQN9T0Vf5v0jYpd4qrwFJuRsE=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.25.1"
      "sha256-zpiY+EizDLanYnf93oqgujGdAQqkJfLm6Coy//fQ6/c=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.25.1"
      "sha256-INReAIKUi2aPGtv35fHQEjSz9S7VV4RptWahxuqqOgs=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.25.1"
      "sha256-jHw1yGj9VRsKLYWzbI3b1leXnm2qY6hUieC+iPEHeNg=";

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
    buildTypesAiobotocorePackage "iotanalytics" "2.25.1"
      "sha256-EvK6tsT0S4kF1BdN/NM9Lu2fgrQ9l4fYVRO89XPRNgg=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.25.1"
      "sha256-TMPUr5RT9F6ND7IL99uXcp5AYCJbyCw9bnx4EkSTTEU=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.25.1"
      "sha256-qx6iI0wNYHsWwGCWtnLIyqaBrqcc3NHD4GXrxUQyie0=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.25.1"
      "sha256-nWej3asj5URYUQbRI6jlwhI1mmKlhP4mXVY90qsmpsE=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.25.1"
      "sha256-1RbQs39myewtwNh2SUAIchtx0Sham/uWrKWAmGXEKKU=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.25.1"
      "sha256-Cw1eny/hylsafHfAhBELpirbjTv7ZiBHcy3qkxWUdDk=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.25.1"
      "sha256-GBKfLgU1zLjiu9HCRXzReR0LK4aRHnLW2KfMYk0wKVY=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.25.1"
      "sha256-GIDKKN+09LHdT72SQ+metNS4tFfCg0qi7oDZmqt/Icg=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.25.1"
      "sha256-MVaQcl8FenrpHkoIB9sVYHgEXX2vFYd2AOnb/gYObYs=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.25.1"
      "sha256-/zxM35oRqcd/mR0lL7g4sIrraEwMYULQoaVp/HUQwBc=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.25.1"
      "sha256-MY3e1jrSRp9s1t7Tl9mM4Ysy4sHoq8qSdpS2xuLpAhI=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.25.1"
      "sha256-gfDE8X90aAEkJkZ0bQrIEbFhUwKWQVQpNkVXru74WeI=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.25.1"
      "sha256-feBTEGa/xjshYQjMHskSyX0QIYBxsUlp8VFZn4F1zh8=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.25.1"
      "sha256-ZIQF+gh05jQTMEYA+E+g8LT5vusi/hm3EFC+f7hbDMs=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.25.1"
      "sha256-zA5rx/dxGTNsNWc04mVVLpuF7nMyuuVsRHUnRalDGos=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.25.1"
      "sha256-0xl78ZSC1A9OlN//j8GLRsqrnaiRjdTg/2uLysO/it0=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.25.1"
      "sha256-eStRE99IbPwwTHpd5FTiidVlGIrhHjK9T/aWRKXlJ6I=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.25.1"
      "sha256-1vAdMrOWS/nsWL/LFRK33G7NJlsOwCj5Zrii8700MuM=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.25.1"
      "sha256-VqIhrN1ipNF4RXGTGjwOOd7e5kWqpTUMbS+8rHkfM5M=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.25.1"
      "sha256-7I4WVXId0/NxqXKX7266MnSp4gSfFINyfd4ENRgTkFE=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.25.1"
      "sha256-2G3ba2byZmzsU1Cww8S4oEp0/f9HtfBtCM5ONr8yaYE=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.25.1"
      "sha256-mhLGgVHM150A78AYPhGDXy6gJ/BCWUUUrsDXFsr5/Bw=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.25.1"
      "sha256-U2oRuMMR5nTQuwCqczNSTGg9Xp8wg75QjKm8BXihKtw=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.25.1"
      "sha256-5k3NKQ+IpRQSYA7OHo1BgERVi0wwzhQ4bQjy6dt2Pd0=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.25.1"
      "sha256-QU2tu6YzbTF4rmS/IYiE7GMUl5+AUWGf6BCuBRw8ERE=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.25.1"
      "sha256-yZ9YcWur+c5LxS1hgltY63IgYg0ehs1bYbFKB6E8AcE=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.25.1"
      "sha256-Xu4HQpBUp6aImKtNKsvlTrQiKWriXOxvOlZSu1EH7fE=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.25.1"
      "sha256-7WfyjgLC/eVL/nL47m2WKYgBBrxXfXg5S9H9WEvgKBs=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.25.1"
      "sha256-ljf8SXSxJUwOWgclJPXnDnLbw0sCIF1or0ukzK/DQoY=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.25.1"
      "sha256-xaJqyruf7YLIyeYR/6cPCebno9Ps15uNlLwAI2oepH4=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.25.1"
      "sha256-4OkvrDwiZlmRYqYsHqfmMYes+DRadgfx9pU04V/3mG0=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.25.1"
      "sha256-3T7nhP3oE8XVSlINSdAsh/xDuiF1hYm3lG49+3DDLd4=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.25.1"
      "sha256-+3pkXJMbs9HCQnfFwZOn2uJ5P3DES9DivhCLXRuUbfc=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.25.1"
      "sha256-U1w8TffyAhdmXEKurRWAh8dglmGvpfgFp3O0jOshTD8=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.25.1"
      "sha256-0KDJ8/OtiRkOkv6OWnFbm4DLLv3n44s4ACF/AeEzhCo=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.25.1"
      "sha256-LMcYBP3+g0YyMcPp+4+DxZWASKo1sYNcbc3YY7BcZ1M=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.25.1"
      "sha256-1JZa9NH6OC/SyKegM1RkGIMwJDxbSBCik7aKTC9osZU=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.25.1"
      "sha256-9RxipPP1FNi6smaWhDRt1KEFt/K310WNDXAysLwbzuc=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.25.1"
      "sha256-yTa4bDiTYSGy+W9t1h+zcuJ8x8yrSoVBKUrw15EXSV0=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.25.1"
      "sha256-CJw3DYxfQWo9dbo8qLoikLwLjTwprlXDpHLZaofqoB4=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.25.1"
      "sha256-YBLEKNiv4BRE+fBxZrLrBxrgnwjLCX7W7gufDQ4Tfow=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.25.1"
      "sha256-htYyBXnVid1XXUPyEympHz/jf9e2xx2cnxd4HvaOAFQ=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.25.1"
      "sha256-sTZ4Fv+jh1SjH4l9evSmpF2SqXL7yfkhPFvF0F+CG1Y=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.25.1"
      "sha256-R9D/cYVwEc/HAS891vM/cpHjf5ozAVRAx1oGJDes+kk=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.25.1"
      "sha256-R8PLtNdR9ymQ7NQrg+w2caSjT1c00EurbKI2eopEpgU=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.25.1"
      "sha256-ImY0tHrxtZXZJxEMwXCO3XloNpxuOoPzEbt/7JSm7NY=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.25.1"
      "sha256-+ze5GYms+hngOUkpAqP7rBtEMdq9E49sPmrx81jzciU=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.25.1"
      "sha256-D26pEIMDQjcqC0EmDkUizlIiy20ShLShrFKhGUZoPjc=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.25.1"
      "sha256-gTxXOCYkF/jb9AsVZRGpBToKSPSRcnwhUXty6NSXMGo=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.25.1"
      "sha256-5CHQIQEgMMyvHqzZ6a+kEhA4oxLL5BqxkziX5M/CuVA=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.25.1"
      "sha256-6fjkDyU5ZQiwWo/kPm/m+6JpR2NjmrdfZQ8KpEKJ4CM=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.25.1"
      "sha256-+ahjkffPZtKJzrqdvk+irhruXuATlq7ffwYkKTbop9o=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.25.1"
      "sha256-5T/gShK8QCbvOdlyCT0l4En4UfsCJq9kQWT1T8pCcpk=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.25.1"
      "sha256-fbo9TWM6isRD2oyClirrmVCD/yCFWSNSZWOY1nkAbo8=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.25.1"
      "sha256-qby7zbqRhERKtKXaCsnNKp21UfUkNxN7ovgn+ydqvtc=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.25.1"
      "sha256-r6DpBRlchtGfTWjgBX9qieF/ol9jIFyQsFWSVhv9EuQ=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.25.1"
      "sha256-SknZ55MUJ1f/6fs/M6D8pQdFA5T1+cE/LwPEdO1owZc=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.25.1"
      "sha256-/6JkPuPsAKADg+KoVDLWogxoFxaONOlPkt319jqchHk=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.25.1"
      "sha256-veLI4515eH7RNobGspj3n2taZXoKE2aRHkLfFNK3C0M=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.25.1"
      "sha256-Z6STpBR6U5uhuuwN0jUTYaV6lax0WOut+C15MZOYhrc=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.25.1"
      "sha256-U6Nnh3am7cuU2nRxolEjYO68PDmu216iK/qXRxbpaZ0=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.25.1"
      "sha256-xUe7nPbocz5X2KA23zhaIfgmzQuAt4GhTs3qjBb/Abs=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.25.1"
      "sha256-KD70JU4ij1TCkFJpB9RdlhZtderHMmhnpVsB1Em0Uo8=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.25.1"
      "sha256-/ofmxL+9WGzHimyeu/ubGjJY+1p/ksnvppfGFeVPqTM=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.25.1"
      "sha256-86pMcT1xCW3k946V/HW3tKMNlElyyvUGQqLJ9C2P2LY=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.25.1"
      "sha256-lHQDdeXh1nghHrPHFO2wK3l6H+RWrFlCo+v8hDYZmJo=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.25.1"
      "sha256-3TJ5O1KpWvle27CkVYqMaNCmtmia6bM95y3aWFIIqek=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.25.1"
      "sha256-I8EU1PauqhHehGanWoNf7i+JBiWhF4LOBP1ZPVGH54k=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.25.1"
      "sha256-Bom5eQ5HpMB9+PZoWSPYHB5jla3cFrY2BCyDckWabGI=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.25.1"
      "sha256-FbRm4kz/GxaDs3YSTlSkYpLePhaoylV77/gclb3V2Ew=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.25.1"
      "sha256-ivJTgZ4/5Ztk7ZJWkb8uAdIv9d5QX0QbhnfNU4n6AVA=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.25.1"
      "sha256-VBHKK+AQTPOy5thvl1gH/DfOajQlCrupa+rP3h7VqfY=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.25.1"
      "sha256-o4I8eY/BG7ejzov3Hs1y4TKfZuXfbdv6jjqAn9aNPXA=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.25.1"
      "sha256-H/tLdJuHNEBI0w94YU295OIkskrFByN1ekighcati7Y=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.25.1"
      "sha256-ZwQuf9rlfeSs44wgtPcJao0Lz5H2P89y7QBvluiBb0Y=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.25.1"
      "sha256-I0hnxRWGsRMt/Da8zSt0cuCbDvuKBK8HULbVyAGEg/A=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.25.1"
      "sha256-7ov9lMR1nexCkf65s/pgCy9Vtd+VUyJO+6Bkkv7eShQ=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.25.1"
      "sha256-1V/emHqt57hc5v6zz5Bgrwbov89vRnYC/B/LWdtHsMc=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.25.1"
      "sha256-VQLNTzlQy8ZbIwZQOLmFsROFFx4Uz26uHknHX6Dw4rQ=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.25.1"
      "sha256-WqjtRmV9Xqi4UjZKemRTmMCwGD9cg2BBqbAdyWmV5nc=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.25.1"
      "sha256-7PZBzCSMCey5zHsCVL60fwO03iEOlgUtEbYPVLZ76zM=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.25.1"
      "sha256-t36O6v9iAG71B+P+P0LrhcV0n2312AzG+6Tnh6xwK8Q=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.25.1"
      "sha256-Cx3PnSzQ5dKSi7VwZv6raRfDnHyDb9PB/BHoUFRvkGY=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.25.1"
      "sha256-cGvvL0lSjJZUP7AuoduimNNLT8GHPr66M8iggZzEIEA=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.25.1"
      "sha256-eHZiMuSIfanu06cxxtHeF3k1jQzjU/5WQA00zzUVQQ0=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.25.1"
      "sha256-x26NLlWyh08auFYhA2bCr6VxyzQ+7w00LbKpTO7W/V0=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.25.1"
      "sha256-Yyl+pY2nGiuDwjv3eg6XIntlNhc2pFrd/v0T1d7aTAQ=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.25.1"
      "sha256-ywY0uaUrz49I2EvJpm4Jg9Wtl3OQzcYhGQBUsFF0atI=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.25.1"
      "sha256-XuPuyCsSDdz3ETarckujmuILzm1UwzKXcxUmtPYBUCE=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.25.1"
      "sha256-Mo8bMMauv+IX1v7Njzjix0+xgICqqWWOEBVilhAhVe4=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.25.1"
      "sha256-CUro+DiCxLkji1qCmQrVJRaaW5SHIYPOVd7+xRnLogw=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.25.1"
      "sha256-4BZnldgRXtY6XfCymsAz7qIyR/0ctkYDtKKsCkrrPX0=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.25.1"
      "sha256-OgIvlBBFKsbEa20TNr78rZiJzDyBa7oLL7PP7F6UvmU=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.25.1"
      "sha256-C8IkedXkHQ3b7T64UmhsAyrWJkVyR6AosMJXPce2Hwg=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.25.1"
      "sha256-Alqzh6EhFqB0+RW4Xj2Kcwm/Uf8WrmLV0gQJXBkNc3Q=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.25.1"
      "sha256-NMFYqTWMzxAHQ1UoFXs736y9dGruQHPznQNa+Bz+gHc=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.25.1"
      "sha256-MF4qteKqIeE5Ff/t77H0axItUZDN67ld5+69RLiasdU=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.25.1"
      "sha256-ynDhs6cUED7FyN3lsW2qxj4C1+bu3iM4aJAmJVmkKNY=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.25.1"
      "sha256-6e/kUWDGZIwF1kWncWG2zQYuOxIHqZxs/CdKlomGBCQ=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.25.1"
      "sha256-3gGMkI6XUd19SAlbUSPaeBEYjb6NpEdIjGbrOsGB3F0=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.25.1"
      "sha256-Ed9TbzWal+6591Wa1/fsBfK1mUvG5Zhe/cWb0ajsXho=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.25.1"
      "sha256-iIOlV1vhLTfgzef2wXSmuYjA7xnxHdIVvxGK41028DQ=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.25.1"
      "sha256-8oHNREd5Qzw6/WUbB9eS7DAuksxqy0C1M8at/wXWQts=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.25.1"
      "sha256-REQPDlOxP0VvwWtgn8H6OllOZF7vUm0w0PTZG8TCMK8=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.25.1"
      "sha256-YhFtahge0fMdlLhjMCBVpb2vfXK79+C/pWU1LSprBPA=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.25.1"
      "sha256-bNSc8duIR+enlHsx+tGodmYZKvhNEnCb89rME3d+olM=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.25.1"
      "sha256-CcyWYEZhkcsK4Cc0DEhhAtZO6l3f3JvayVGnVGLGPrQ=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.25.1"
      "sha256-sC1cBmmtTPD+OnNxhkBnOsV+OCrMrUihTI91ttp7mHc=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.25.1"
      "sha256-2HxzyANMkFirBa3HRuuYVplBiWx4w3EmXXsDZc+J7yY=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.25.1"
      "sha256-5dqjnOTv0ecdnFV4KBZC0cOWQetbQuYdQnZfhAQpTVM=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.25.1"
      "sha256-VCy/iOKouH59pW/ZWYE3h3KpSYssykaJf+/fBtBn2jk=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.25.1"
      "sha256-J1wgqdueLzQVc+WprQrM59/idKjsfkwH7RkhRzcRMeU=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.25.1"
      "sha256-dx4o2BwambQ1yerQmcwb4o5kUSZtT5/d7r1rCR9mrxc=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.25.1"
      "sha256-36T8DEfhP6VRB8FaZDYj+Tf4X8veszit1T0oU4Iz9DE=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.25.1"
      "sha256-jfqJnb/JBDwsSbWcU6Jx2QQ5aNxPsSlWSpelnHfI2oA=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.25.1"
      "sha256-13Kd6kTRROmiT90X9NxmuYrXGGT5v2622wWVjg5Z0B4=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.25.1"
      "sha256-v3s/yij/m0wn0e2igkAsgEDxqLMFirlK+6A6S9IWfdE=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.25.1"
      "sha256-2xwgdhBz/3xbsDfHTUGEKDZIAKROjJMTY3r9d1CEyLk=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.25.1"
      "sha256-33vfo2JuPk0vhqq1zoh664pNVrZmOdxSs1WlwJfsSjA=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.25.1"
      "sha256-zr5xYHvjFEiMvPQQlpmm2iSqfvckpz8RIIWMJ04Y4yo=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.25.1"
      "sha256-UjasiJChpyYY1aetTdb2asvKAEmACLcbNkwycxICYVU=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.25.1"
      "sha256-rod2cAIgI2J/jiNZgeYbv96C8iZESw4nkLYqjy433oA=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.25.1"
      "sha256-hO8+y0xp1rF1okyV2RvopptK7nzJMjzTzv6qO6riU/I=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.25.1"
      "sha256-hT6WD7+R0VGCwZtm3d0R2E4edZiN63I17BT7PwjeflU=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.25.1"
      "sha256-kWck0jciPxQA7a9BSquGjmODtRU+czu/ALYQj1KCfb8=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.25.1"
      "sha256-uqadHqwcN/NqSE0bwOZ/nVSjIsXTYzT7ukKqFy7932Q=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.25.1"
      "sha256-Jy+zO7oAZmCC1GXQlC0wTl8Yo8nTfRhHuS2c/QRZkFg=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.25.1"
      "sha256-/XGQ0ZTB8nKpSmR/9/4fQQiG935A4LauI9IhMXkX6yg=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.25.1"
      "sha256-0QSS2edC+Zu+ejGHqcD1BM6Bpe7U8YIL8UL6irzqnb4=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.25.1"
      "sha256-3jTwBTOOlz6S1PE5J0bs/0D4gYTj9NrIbu9HVvwYyYE=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.25.1"
      "sha256-5CLojBa5NT6SiX2MIMK0x8Dn9hrgsgcrXtrGfjLU9hU=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.25.1"
      "sha256-pCF+YoOT0JyHzFJuDQZVOsU/gXoVwRHNMp5jA4NFNdY=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.25.1"
      "sha256-a2j9C13E2wPn2ihrI2Uj4rKQwq0kNF7yWN+3HP//MaA=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.25.1"
      "sha256-c4mD5zrUirartw35srgRiaTAwL0r1HgU4pgg2sr2g4o=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.25.1"
      "sha256-+Tn50szRX2GsJ0rcEzXVOVg/uz5MUPlI6xqfgxh2EEE=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.25.1"
      "sha256-0Wg6O+Zo9Dn1Okb3IDemWt2jc+3VZpmHlf+DzMoMkK4=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.25.1"
      "sha256-5Kgi5daBavtNVS4YUOO7g90dJnmdLdELC07wI7ePcXM=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.25.1"
      "sha256-CKGPfkrN1HyMdsa//DJ7Bch7Y1thc+MVLQV0Jji4YJw=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.25.1"
      "sha256-bYgAoR6KZV3p7uB1RxBjDwmrbT/y9d2qqRm8LaubAGA=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.25.1"
      "sha256-T0oAXM+In4CULYQ2VGC2klP0kDRHbT5upNxWy3HZvpA=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.25.1"
      "sha256-aSv3CpJFP/1QPzE5zCNeG/+fJZv/HflupdjiBlklB5U=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.25.1"
      "sha256-8rheniPeQXu5Utno3uYGSiKoFWKAl2nwsAHWGpYp0OQ=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.25.1"
      "sha256-tf50jHZwJH1TV8RLgtrysdZE2pou/csX2kHMIxpMVe4=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.25.1"
      "sha256-bTE0DdrDoqsMaaYzCAf83e3b9jiSjtSQXSGOz8idZA0=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.25.1"
      "sha256-TIKKaHH1EKBi7pku8Mm7ioQk8Wmvaf930QAfsBWKoC4=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.25.1"
      "sha256-D2p2YaTgLgnFruSxpiQrCctoG3ACdQAYSv2cL11z0dA=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.25.1"
      "sha256-lP7Yb20X072jM8RxF23S0GnU7JA8fk3eETC3HeqpU9o=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.25.1"
      "sha256-yA3+GRPLt0kery3/6bZEdYoQFXkJzL0X/Z6O8VEqMfk=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.25.1"
      "sha256-PwfHjcjp3QULZ8RwBwVLHOYM2Xpu6zaxhz2l5cvM4s8=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.25.1"
      "sha256-0VKoinD0qL3qlx9tsuOPSjpS6kMZVvlNJPmt7vtqT18=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.25.1"
      "sha256-NtGZGmiqsUDfx6/Mgod9foxHsN79SmWhPgSm+f7DZ8s=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.25.1"
      "sha256-RC4ZODQkzpGrYJFdTXAoDINnHnn7Mx13KntJFYWRdCc=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.25.1"
      "sha256-mMiaTQeCQipDPU7yeEp/vBM79UX2z8ykQZ9NkP4/TrE=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.25.1"
      "sha256-hgaJ33L3J7E34vzjIX3mmPeryPCwvT6bsIri0ydxuIE=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.25.1"
      "sha256-G5PzzfZQHL+rlxjAnknjaQ8qLWKzYM9KZb2FNQnT+EY=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.25.1"
      "sha256-NCgBo+f70ag0P0/5K9j9qjHKlmFYyH4hv9BJbEAvBSc=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.25.1"
      "sha256-5teV0lI4CmF85kT+drAsEkIhgo35g5ighO56xuzwzKc=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.25.1"
      "sha256-SEg5HRuZeM6sM9fo6Xhyb3PSJqGTA2rzfQme86Wk4OU=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.25.1"
      "sha256-J909yOVc3k5L/+D2A1X/lQeUj5QAZZseRclm19PPU+g=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.25.1"
      "sha256-avrQl5UDznK9XeHrT8mrqgsGVtHYQnIoH5QELCsZQgs=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.25.1"
      "sha256-NJ4c0IbysfJj9g2vVN2My4cjZmrfPPXZltfcx4wyz+Y=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.25.1"
      "sha256-IQTvO1eg+FZQBgwPYhOWicf0UepFZcC9co2KFsY2tXs=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.25.1"
      "sha256-tTLiDEhn1yNKAr2YVvMlwMFgcaGRCn/sgB/2s9wTH/4=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.25.1"
      "sha256-XZDMQfEqTof4t/Ib/CTAC7MtI+q4XYm/yIagLpM8lxo=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.25.1"
      "sha256-WUpjeRnFUypY/u7/yTeEAETHQxxiYfjmsgWzYTeoY/Y=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.25.1"
      "sha256-tn/drUwCeBR512eVttK8fV3Anueh09XJ/jazATKfGvM=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.25.1"
      "sha256-Ix5h8GkPJfMGul/SrN3V2Y1FMGwMmc+M/smTrP+eeu4=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.25.1"
      "sha256-1r1U5sh45xD8gepfm+4RVCh9dkXd0ce0nSaNCcbXGxk=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.25.1"
      "sha256-KV7C7b7pOUbF2vR1e1D+COg4gcv03Fo1WxTK265OF/s=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.25.1"
      "sha256-TSU+o55xTECgvUj9IJZOOTaTcRBj+ZyD+UzVPOBd2KE=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.25.1"
      "sha256-CTP+nEVc3xo7vOJci9+6eSCxO9V2m6AyT87bufEf+BQ=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.25.1"
      "sha256-NFeBg4RI3rumIRNpResrvWvwS3EJIICGPpjwk0Usi3o=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.25.1"
      "sha256-LzXnnD7y5ce3u9dYmWCXI196SEjnyNDKypd+1SvFPIo=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.25.1"
      "sha256-Uz3KB7wefEnDkgctwYedWm6tugsh+Hl4tsSUcOa5d+0=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.25.1"
      "sha256-HYhiSYnCfNcMrg8jg50KWPXoLURwtwsB83ipgrppvwk=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.25.1"
      "sha256-Ra5jZjeZPOLF7qduM/m5C3GDyfRo9bEwip/ZI2BHtLc=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.25.1"
      "sha256-W6q0Skbf3pmG4HhGOk/3qdDhaO/JE1I/pSZk/V+gBh0=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.25.1"
      "sha256-+5JPzpS1F/KNLHzCjnw7Msou4kZlAP/FLylcSgMfI9o=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.25.1"
      "sha256-LoTEJsKXnEDFT01wnwAPjsUdfWnNKRnnXGhFQo2vhOM=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.25.1"
      "sha256-5Zl/uK4FMTm2U+GyvlO/8MUyPre0//iWRU89bzmZkZw=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.25.1"
      "sha256-1szHKPThLxDPWbjQBBxBA2SH0/lWAEGPYe0PMu6enq4=";
}
