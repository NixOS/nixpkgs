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
    buildTypesAiobotocorePackage "accessanalyzer" "2.22.0"
      "sha256-774I1TXtrPfjpNe121CUUyQe742Z7nZF8KmtHBQA7ig=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.22.0"
      "sha256-dkFlBYanCDzoyNfXtML6Kv9P8ETCLtOyVD948hoE0Yg=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.22.0"
      "sha256-4Zkodcc2faCDdNNPYhj5zGsur+Q+xHkyv3UVn8cMtEU=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.22.0"
      "sha256-9Eb1jQYws+leyCC8LkmehQjrp18nTKf1tlutopVFaGE=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.22.0"
      "sha256-3blXs3DxqFum7+QOGgXWMLM1PSy7ilKzPPuWvjeiJUM=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.22.0"
      "sha256-acSuANDq6fPhk3w5J5p9QX+oiakC+ROgkjbbSoiYR58=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.22.0"
      "sha256-s6xy9G/iWolWbyXEyPR4bSm/dweZiE9U0pfVOpPlkTE=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.22.0"
      "sha256-fWVSy9gkHlLBehNJbo5FLfCDlWqAGH3Zd7hjk8X4FF4=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.22.0"
      "sha256-8G/o/FDMFQbpsxTTdrTN8dJWDUXLlGxuiAO0emwqMrQ=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.22.0"
      "sha256-ITDjfDmLPtOqgC8uDEVdIirhpAlZ9ghe5ZSLjSMkLzk=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.22.0"
      "sha256-UEUy4IpfQZggKpseBMaMyLdPBX6ud9KK/wjR+wNICEA=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.22.0"
      "sha256-Q8n/IsRqoHG4D3ooe8hPPmXtgfnql0vAKBKj0Y7BNq4=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.22.0"
      "sha256-oj5R5iAIaTL6pEY04fGMUbE0W9dDm4KYVN+5McFI09c=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.22.0"
      "sha256-cunRoOZn6vJoTIB55HzTnYfj0jdWIe9XkVSNkYwlQTM=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.22.0"
      "sha256-vbHA3mGtLteDcgQt0ztNp5uF8AWOEwWMq7RWVxA8+NA=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.22.0"
      "sha256-O9dlTC7Q9VsVvz0stoggQE6vh6HX2hvq1oT3zKc1tOI=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.22.0"
      "sha256-VX8MzWpIt0MiqGfmeZ1UznrmMfJjkB6AtNSN5NnbR6o=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.22.0"
      "sha256-jC5biE+Qp3qYmSxudyouCDayTHl47GPNKNJYfmDieVY=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.22.0"
      "sha256-sBlop4VKI3Fe8rtCAVFU+MsJXCXwZtyzMkyyM0xgTxI=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.22.0"
      "sha256-iOUOCy+vlVd1tiSUCEknv4Q9f+49NJr5rRpFORzVFyg=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.22.0"
      "sha256-jAyThKObnErStzT1gmlmJcQ0OhDg43n3iJP4qNNj0OY=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.22.0"
      "sha256-2+A1U975n5Ab88AcBOl85j7FLkhVMy8GDIS+VUq2e+w=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.22.0"
      "sha256-SU+sOv+kSqie700NCsD87jvkX3NLimJNelaJ3f7CbGs=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.22.0"
      "sha256-65HLrO1AGTYVAcxeBXG85Fapha1mzt8UgL8ONiMiQK8=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.22.0"
      "sha256-pVs/lo6O01dqIGNLyFASJl+LIwv0tUAUDIKhnmEAdDc=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.22.0"
      "sha256-i/MdzrJrWlJqRPq73IQ9pWsTpAAaeslSPtHW7lZN1mY=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.22.0"
      "sha256-7t0CK66iKlbrY4kIC+Jwdhp35dRgNPthCWUV/e6GrXI=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.22.0"
      "sha256-rbrurBPHq50xMkO5Vh1bo55J3K09bL2K1ppKlfOEJuk=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.22.0"
      "sha256-22TKyYor1b2qzq7Zc8uiqhl1QlC9DRqjM91InBi5qOU=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.22.0"
      "sha256-2fCgoLxZd7/cYNhxPOJagjy+ROGoC2wDuD+e3AaUe/A=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.22.0"
      "sha256-vQhZeuMIzphgQYXBNyrI2XZlY+sR09lbusweQ23JB8Q=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.22.0"
      "sha256-txF+ocXl3KjFCfqit/kb9mXIRW14SxCpy2PWczWBBTY=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.22.0"
      "sha256-wkciK6H0bw0ooPKdRCybZuBobPJHDme6jSn8osBAukk=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.22.0"
      "sha256-Uw4Euhct1i+rWMTuRKuu3EDhAVrEcOJK9THJgOed55M=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.22.0"
      "sha256-jfy6yBxEQGV77vFZNmB2He1SeVU63P43rE+NOdhK5UE=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.22.0"
      "sha256-5K0Phfr6FZwv3tIjtxwgWBmPb/8ewyjaWf/fVTmIXLE=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.22.0"
      "sha256-NFkPUW85qS23L6yxfLneGKvRUVUcnKFC8gKWl4eYKAE=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.22.0"
      "sha256-oF4Rj6tWmlR8mFSzG+RXSyxUewVX8lQuMSqFgy+lTYc=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.22.0"
      "sha256-L2ichNZIhvfA5r3LwPaVPY7un0rDzH2oi7nsgMfyDSo=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.22.0"
      "sha256-sA16Teac3eeX0dZtagCMHJhY4nAz0k0WO/mBs9yh364=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.22.0"
      "sha256-phT4Jvd+r6Imv9hXvHs9nhOPCdIiY5QNsOQCWRpdwBA=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.22.0"
      "sha256-FS7vqDj0+uSitgON8T6JkqreRG9S+GhHaizDQR0ol5Y=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.22.0"
      "sha256-OVw9zlZhPrELXvw5x5cEW9Ijrs+mSJat6xymFVDB8NE=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.22.0"
      "sha256-G0eNbnLZ0r0H/FcBJePXhvi1P6ICby5s3BlbSS9nHhk=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.22.0"
      "sha256-Y4k1LdRHZVQT1WgYnif+hL5lRNLELvidJnCIP0WLhzU=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.22.0"
      "sha256-ecF5Ibbuvd4E0iH/GH10u6oWBUmyrBNLXqZgsJ4dGug=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.22.0"
      "sha256-JP09W8BAUhqEi5y3lWYqJybSVpoJmmL4a5ifG8rklcs=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.22.0"
      "sha256-PL9UDD6Q8WP+LBR0AzUhxdMu6gqUAFO93T1PbJkK0Xc=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.22.0"
      "sha256-27NVmbzXHQdBlC+hu33/NmY+kLPbH9JPNr8JSeYTQqA=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.22.0"
      "sha256-6vSDSIX766QcWY60OfUsLw2zHosRFuHT/gbuG7uLLcA=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.22.0"
      "sha256-IRKzio9xZyQ9JEaBrpkGGBrvwMNU03Yj5ByQgJ1BKIo=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.22.0"
      "sha256-kS0KvOY3hNV/2Aea7FKqpqVxds3CpzQzv13mYnSXOjQ=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.22.0"
      "sha256-QfUxRPimVJ61CuTIbZKx3yteKb/Dpo3X3odo57KR7/I=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.22.0"
      "sha256-13rXJ6FORJrB82+636j+73L5AroejnLt+mhctskHa7o=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.22.0"
      "sha256-iY/Q1ovxLejtrA2nHcVqXW/7WIUM556nu7f5SFbW7hU=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.22.0"
      "sha256-9sesg4rfUJBE4SYgZk0SpihVrdh2R5sHpsGJt5x+TA0=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.22.0"
      "sha256-gZtmYuuyqhX2y1KP5U4+JBUM8xinq/s6SM+u+pbmSCg=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.22.0"
      "sha256-/75t4UzPxF+MECx1juZR3mGGMIaWDO6Zqs5ZuEn65Mo=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.22.0"
      "sha256-2qw+Hvb68WFhXFApBIUXG9NAKyqSY4qbjfxcxFu7v6A=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.22.0"
      "sha256-Nl250zSOaGAXtOUMSg8dNKHSH6Zl7lF0hC3+NJBPXF4=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.22.0"
      "sha256-/KjsBiC0O3bbzCsv3Yj5FRRLyPHPR0UgMo2A/vvdWFM=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.22.0"
      "sha256-aJMjbjo54cjCrHJqFhPnMNBZ0D/fxhbLrccuFh2FJ+U=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.22.0"
      "sha256-6miisnSb3iXDdvWif9WB7IIFVbwx1ixvqaK0t563PD0=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.22.0"
      "sha256-FNUOrFeS7fGB9y9QH2Nt8KhTaXQiMyToQYdzEChWK7A=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.22.0"
      "sha256-7ax9Mi3xhfDoB7tJu+DtWif2opRSTp76WxqqONU/41Q=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.22.0"
      "sha256-zqvW1iM55ivSwaHdGFZMG8hDKYP1f64PANc4Ms/pE4k=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.22.0"
      "sha256-i23oyVNSWVYOGBmf+Es4Nv7RobLcaX9G8xmMBBbUloQ=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.22.0"
      "sha256-hvo5J5BWLSR3an1I/yVTCO3zTtu9tFF9HdUvm0ng0GQ=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.22.0"
      "sha256-/uTn0PFh1QCsZjyvYG8U2k9KK9kDi25Y+wzRwz4WjpI=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.22.0"
      "sha256-UBOOmoQVtd/3PuAIy7kzidEpgTKlXPL8CbMDUHRyvnQ=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.22.0"
      "sha256-se1tjr0lwGpaqcICoDwc4gnyiqgCmZIpdlQ72xUBkUE=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.22.0"
      "sha256-kJ9HJ8vN1xdSyQSbvuQ+uwA/EDRYOHwW8yYe4h7N+l4=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.22.0"
      "sha256-1e5Cu44oTHkAHP02PJzf8C6eVlU3KhCs5Ys/uhxtTBE=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.22.0"
      "sha256-wJUd04oGKGxUl69LVZjsV1/et9aDoHt3m5pG7mYcLDk=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.22.0"
      "sha256-i1BVM3LPwuJTYa/0uvLlHhiyZiCMRk1Ny305EbIPziY=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.22.0"
      "sha256-3PZzIU3NJQb1RWukhaZuXKsuL1DDrU8rsJYJSVkE27g=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.22.0"
      "sha256-/pmBY/yG0bsyautHeFyffcXR8v5Mp3t5r/ElStpPQQY=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.22.0"
      "sha256-3icLS3wkyrsvbqmks1bFWZ3/pflnuNzjoovX1xGWpXc=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.22.0"
      "sha256-2B/BhlopuhTuw9V3PYi4JFX+QTL+fJyswz9tTl9YKaY=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.22.0"
      "sha256-M8WaCHLLiDEVO0qWWHC4EIyzdaxUfZMPagSyXvbKke4=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.22.0"
      "sha256-InlpLYKUsqSqeKpCMbbeD/r3Mbzi2cV8LsDSBXpkN/o=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.22.0"
      "sha256-9TPbxDd7e82qPUzqTmWT0+Fg52P+8HBI98Cb3qcrrvs=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.22.0"
      "sha256-Crs2aaiOYjDLj5A7n2QULdjowkpZttr0JuMP7QaR8lE=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.22.0"
      "sha256-g3l9buYkUqoUNgE53DWP5U3NlCPCu5gxK2LxutJZCLw=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.22.0"
      "sha256-dCO/V+k764wrGbvPXWnX1vRexmz1zfTDT8WzESAERdY=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.22.0"
      "sha256-pIWJZJnO70H8UjcqWBtuoggVPWh5rN7dhIVwQ6OhdgM=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.22.0"
      "sha256-iBDDgq5DpBk85AH+P3WvVJfYLkqegm9HbrupPv/z2uM=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.22.0"
      "sha256-1CWV3kBk74y4CDxZjpRSvgkPmTgcp4J7pkthFvDxIIY=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.22.0"
      "sha256-G4Ea3JZvpTfFH+uifY+v5Vic68QdF5swhadFpdPoYpc=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.22.0"
      "sha256-ew13XwU+SQOljFpDiVDkvfRIqySDkPAEHCsT/a+T7Rk=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.22.0"
      "sha256-AxkrCquNxBakMriLdz2WqwcpG4tZlM07Bp7duDsVfD8=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.22.0"
      "sha256-cFhJLx8j9sxnnDL8T3MJMhVKB9iLnULg7SxMuU6zpuA=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.22.0"
      "sha256-RrozvADo9QhLzmYrZbkv6CqqAsXqmNPxrNj+gwIrJSs=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.22.0"
      "sha256-MDZVTe1TKHgJNSipw9XlMcrn2uds7um6lRzpHTEmEu4=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.22.0"
      "sha256-tLF/Enf7ii3ZMrh31iTmg5d9Ind1S+xg/+9lIB0j38k=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.22.0"
      "sha256-7fbtZofJ4e4qlsgO6qNjiyxiDqhLlDfBacZPZCLXx6A=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.22.0"
      "sha256-pQahBGreSEdYC0m7WUQ2TO0y+hlvt342/XwlC7VYZ6M=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.22.0"
      "sha256-QZPlFdLirYBBQtGJ5xRIsG8rrFeoFQWqccw2/nPzmzs=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.22.0"
      "sha256-E4HJ42BZYYs1r70JArgEBuc9DsGdQ6W2nVOdI/lJgOk=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.22.0"
      "sha256-IyOQ+2kBtX/e95LKqGEznuSIm68dqAlDmcN98Oma8Eo=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.22.0"
      "sha256-pDzURXy8RXK2yJteb4ghSFM6igkvcA0W8gf32RDXQwE=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.22.0"
      "sha256-vCBUav3rf4s7ASe2Xtw9DXHV2Pha5owLewkLxW1dSK8=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.22.0"
      "sha256-ay4pPWBa3oL0hW4UhV06Te5og8mvPu9HIvQH0rGYvfo=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.22.0"
      "sha256-BZlo/ksnLKOBQk0Ha2hmap9K3adGlO3VxqNz4AbT50o=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.22.0"
      "sha256-GVOzochs9I2VH6bzR1/gXvf1t79QS3PGDZ6IlietZG4=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.22.0"
      "sha256-q/pTWkGmGFb3eqBb/Ycw5YBsYQcsNUXeXKc2NGTcXtM=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.22.0"
      "sha256-GYiVlvwnfE5p4eu9TgiD4XDBs81kC5iXh/gwTLD3NjU=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.22.0"
      "sha256-JAYQKMUrYsVZIcLxxq5HK/VwUsieM53Mg8HBzypI+mg=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.22.0"
      "sha256-7K5h65LrXLRjqp0sGDE4Z6DesYzxV6woQfT+gGizluc=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.22.0"
      "sha256-Q0pVOC3HgSNMJkZYO/pIrQfz9XSOdM53dOTVInfWf08=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.22.0"
      "sha256-uu83undxPrbaEZQvlTeUtis16AbgGGikiw/RlqcRGfQ=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.22.0"
      "sha256-QYfueAtYDpc/Q4VXU+SqlqPnQZOGJfEznviiQ3BfTi0=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.22.0"
      "sha256-j/LWzU7CFFSE4v2Xl1SPLJ+An++AjFt/KTVOj2sPx9k=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.22.0"
      "sha256-ZiR+eR/QJmGxEZQz5GNX2kd8P3hH9WKeobvi4ChQKcI=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.22.0"
      "sha256-xpkvQKSWVvktiX9gn/iAA7gyKFE/V3q/gr3Bb9rHaro=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.22.0"
      "sha256-wKgvGgj6hfJrvEGjNxMuJ5DTFhh0d4cutSS/8du+iew=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.22.0"
      "sha256-fsZvKKOSpEL8u0Ok3RmtH9VEm9wA6Gg/Eg5Svn9mjpU=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.22.0"
      "sha256-Jq2cSoGCGisX9a6DJ5FyFCc/BIVx2mWxUIcHjyS446c=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.22.0"
      "sha256-qscVqOSqtcxwHkqyy3a83rtiKKl6fq5h9XBWE3zz6Us=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.22.0"
      "sha256-igN2Ra1ckXXT5n+HVjME/k3TX5gbNu15vYUtXmQfoPs=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.22.0"
      "sha256-J1tkl71/lKJzYJuppe/GXeUm/W39kNjdyKpiKKoMlQs=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.22.0"
      "sha256-K1rIFYdkjXDhbMyFZH3Yp0YDmLaYDxSeveK9qwgAEgc=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.22.0"
      "sha256-NpvQxqnwxZhy4R39IO4O/HVbeMj77j50U8Xf+vonpQY=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.22.0"
      "sha256-9qSNQ3HPngBm1OQIJzCLIHxPZGaKKj09+2gniQCUk2E=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.22.0"
      "sha256-ewWTNvhI8hmLmZ0pV4aKMLy2Nk0RQeFLmb8BcoEXLHQ=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.22.0"
      "sha256-QrWDDip3PI4Al9ZZErFHleeBS8XQHAvMj1G4dFtS1PU=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.22.0"
      "sha256-D0kG0EDaLu5EuoYn9ycrc5xPgcAchkV473NlGFT7NWA=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.22.0"
      "sha256-pYUims8YaT89VZPIjuCakFsf6npK3f2cHbqbdfW7MQw=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.22.0"
      "sha256-5GbN3WwsUzNGXLLq/HENXsHw9HId36pu1m3JmQplu1M=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.22.0"
      "sha256-cM3wBa9uvSArXsLdwQnAXcFSHX3L14vZMDmk6gZMUWU=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.22.0"
      "sha256-UlDESCTs36HTSEdWd26A0q2XbD+CkDoTVFgN98N3DA4=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.22.0"
      "sha256-6J3YiF7Zm6tGqiWWmUOSKUoOQDF+c+ogaHl7o/0VPjo=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.22.0"
      "sha256-3p8y5TlL3OzPV6BHahvP0hzKNeRDYX2pombm6VqvQAE=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.22.0"
      "sha256-HI/GOR2lwuIlX/HIyarr5IjKA1oOaYqMSx8+r94iyTU=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.22.0"
      "sha256-MvzJnp9daBoHIj0EzAUOAu3zNvlxE6w8ZtUTEl20N8Y=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.22.0"
      "sha256-0E0TtmnDsUS8UsUp30tjTCHMj8L7fnpZR6Tr/upwfCk=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.22.0"
      "sha256-TZNPKx9V6fVzSOyAtIDfatVrnzndns7qQTfamihwwlI=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.22.0"
      "sha256-PooJiPQemCvy0TDNeFUNQ6SOTHkOveqyc6AZRPXddJE=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.22.0"
      "sha256-js+G1ckKh6WrnOLPi9e6ZhXxz3Oob40sLOIYbgdE8Ig=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.22.0"
      "sha256-kIVbk5h5FXL4zDXJHYd1W7Q2QB54vNVTeYz9b1PNKb4=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.22.0"
      "sha256-rSxgMT9oibt1MfidO/tDOFyVBc5gHSDUr47lkbdsD6Y=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.22.0"
      "sha256-Sg1OVOJjCttSdBnFANnJMPxiLKc6rNfdohchzTZ6Y7A=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.22.0"
      "sha256-E9k2RzxSCPgyJ+bCeNKFTn6Mup8lhrJpG7JcIxqz0KU=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.22.0"
      "sha256-cXMdVq2u25k6CvQY6YoQ4IFnK8uPZAxOIEqR9XUsjoM=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.22.0"
      "sha256-IJwRCPKKNM67RCauePdTaYGXu3AP9TVjb5U32JO57f4=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.22.0"
      "sha256-jSoP8yfJgRmrB04USAcsLMC2pTkIvyNXHBk8NajC2mc=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.22.0"
      "sha256-jS4TG1BpySpDByWXt5tIZq8L12A15YEs9fVa81MpKV0=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.22.0"
      "sha256-PZynB4jAQL4LylFlMlgSbErUQyQ9asCNQlX3W2bJhjs=";

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
    buildTypesAiobotocorePackage "iotanalytics" "2.22.0"
      "sha256-5lS5QJHQ50Ppr1LtlJ18jucI2qG8PfsnVGT6gBRnjQM=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.22.0"
      "sha256-VGQJdbS/bEWQ4W00+Yg8CfKzEwdT9A9G+t6jyBDrKnU=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.22.0"
      "sha256-YMigEXhdZkcaT+n9Fbl4Fcw7iMOLPqU24E2OM/30xjw=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.22.0"
      "sha256-h9eRdh5fUjfBBUiHkR8kljVzhFTIEvwLXsZXiVFIfCo=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.22.0"
      "sha256-fM5Ki9vKi+pJaHoxnAYoOolLK6NM/imGNe69s8K54bg=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.22.0"
      "sha256-9tNYETHROFzLuI9RomgLatklqdfr0MMx5PL8DeM/ZaY=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.22.0"
      "sha256-dPtJJwjguH0/ulQyc0PvBUDczFozBdYIJ0cB3paEHfo=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.22.0"
      "sha256-76GVd5cKsVns06IFsiCbf8u1U0JwAL47YMkoimW0iQE=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.22.0"
      "sha256-g7adxw/KSBkvQxYtcVg2Uxwr+7jBC6+G+IdtRlM/szU=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.22.0"
      "sha256-CoLbJ6ocP5VC5viO4dt/XtnUcf0SuJvptwa9RzoLJtg=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.22.0"
      "sha256-94mPO3XRIcFKsQclVhnEp9vehZNQpFSyoTi3dTsPA0w=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.22.0"
      "sha256-QxV1vq3+drtjRTA/ZwE1F7kdvS8lWXQgSUesMlP2L4M=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.22.0"
      "sha256-oyP+yuOi3RbQNG68lgiHReEcelbkmC6i2Y962+ai5XM=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.22.0"
      "sha256-vSBQbddu5xpmR4J3lYRlR6D96M5WCCurdrEvsVwIqS4=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.22.0"
      "sha256-+Un6+KbSLJarlbk/t7L7ADQ6pmgsMsU1z5zsMm2xM5w=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.22.0"
      "sha256-wiX+/9m/Ou119WlTYChF9LC4d7FGV8Z+O9U2PfkL9eU=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.22.0"
      "sha256-qM+3w6VTIDp1ZWtt3E3zjns/AY38f0lRk+icoEfHHgI=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.22.0"
      "sha256-GVLV0/tw7qDPiNqj2ZzWfN2RHAAAvdwKDa7/uch+O7U=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.22.0"
      "sha256-MsGW+N7q8kEijzG7eakrPeAVTvMNLG/XpyS1yT1rbjE=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.22.0"
      "sha256-25Cz0sZYTHynV2Q/u4lo0dfk5G6xbCXt+XPoJxJLZ1o=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.22.0"
      "sha256-UfnJWV0LohEfXxPUrNxtMkjcyoSoA7cAYa/91AaDvlY=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.22.0"
      "sha256-+3n/6/EbZmeaZ459VFr4WWdoEkE4D5Egu5/vhayBXEw=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.22.0"
      "sha256-x9VqVZYOoC6cKnOttuDsfcp3J7euSXc36uhMax1SSUM=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.22.0"
      "sha256-1qcLB0V8daH8rnEBiOxQ4gFDeeG/jgSPBVmOg/Q6W+Y=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.22.0"
      "sha256-rc6O/FlwOSTFpBlf9IftYzssk2vlJjwDrDghcylqbGA=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.22.0"
      "sha256-cRnpl0XSm62cfrQDvXmmfspQCDHL2ZE7jzP7paSGRsY=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.22.0"
      "sha256-LBeBX3YhgU0ClxUfgr6Nx5NbSWkFzeNisHkhqy8TeNI=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.22.0"
      "sha256-he2H86tQQLPj2sAYr0ymLN9r1gn8JD+Wea+pweSNpjw=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.22.0"
      "sha256-Sbfj/iPWlvyataiUpbiEIc/3zkBlVdMfV804uIZOi3E=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.22.0"
      "sha256-hfkG7IFqKirFS2oHUlLTW6dNnxB6aracVCdaZMrZ4m0=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.22.0"
      "sha256-M+cUEoSWd8B316+MuXTXAG2qJdhjlRjpAHLPENOLKQE=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.22.0"
      "sha256-ciKvrhoJJQRkAJzHu3Jq+vdBuIvzh5fWePSC466EnRc=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.22.0"
      "sha256-8u9dPu0JEg0OfI4/Iqw4Jk/vcjRoYfR7WISY4H5E13s=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.22.0"
      "sha256-HyYDbt8aGGsD2afomoXSm2B5zTqdKHzo4FhBmE8Z8Ek=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.22.0"
      "sha256-HaexawdY3kr5O6sBdQmHCy2aJKqOylBRq3W/kzTe3qk=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.22.0"
      "sha256-iGexg7/ItikVgyMkD/LdpZdL6Gergu9/tYQwyAgy3qU=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.22.0"
      "sha256-y/eO57cyQkbfo4lqjB7/GN/jPU+RiPSiT4Sx7S4XaDY=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.22.0"
      "sha256-aROLfsc51jC3xhxlwqTXzNjBBX/uVSp7C8E6CbP7MsU=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.22.0"
      "sha256-Zyd0olPEQY0Rvw2m6l+u3CbgaZxBNSZZF1Ep8PTfdZw=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.22.0"
      "sha256-TM4gkzjsa9MLQquxj9X+ace0c0tzQ/I6WaxMD0VrBcM=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.22.0"
      "sha256-NYcdtdIwKyP6rXkhAzcsGvHXr6rTtKp01T4yBsIog7M=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.22.0"
      "sha256-GQjiDaC8zu4z6NRiDXE0o2A6N8mT20iNKUzZuV4NCsk=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.22.0"
      "sha256-3QevdI5IktoSUBzknsmguCM+1yhAV/HTtHE4QxPYZHY=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.22.0"
      "sha256-3alYDnfO/tjrlblrWFwmKDgVdq8glq4yt3J+AtgcBic=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.22.0"
      "sha256-wvcrxbFZmLkOQ2tK5cGX1bOkUcyU27yvWa3hIfJ4UWk=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.22.0"
      "sha256-+Ei1NLs9W+HIM98Zzs30lb0Wq5MsPxdki7+eSaEM2yU=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.22.0"
      "sha256-+5XfrJjWZwsmcISCngVFqeA9uv2LjKqeiAK9a6gmKpU=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.22.0"
      "sha256-InGUZ9wXiL+WlalhS2cwD4thIQm6SMZ70I0OBl5TjF8=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.22.0"
      "sha256-MdBuMahamIbJBE+fQJY89HF8gpcWMrXmOnSCmg+OvFY=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.22.0"
      "sha256-A8r5x1MNLdlAnWYKbxDad5MNR61XqFex4L+yui7fvTc=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.22.0"
      "sha256-Ybsh+XfWThqllODz1J4nj3axPCGub7GZceV0IMfbM1Q=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.22.0"
      "sha256-BryzD7sUww4SjmEtKjUe1hasuxXzzRyra7YQOcNWJPE=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.22.0"
      "sha256-6FcznylrC+WyNxvFJ3PkCH4Z/9756njTbV9zUi0UcS8=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.22.0"
      "sha256-9OWdqUnDOBmDqQ0ueeuJum1eu3M5dustNzDmMsbFT14=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.22.0"
      "sha256-kADWppbEloZYsozQsdV1ypSXclK6aa/8IvHfxHXojOo=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.22.0"
      "sha256-6mpiNHKHKUQo/wtlaJzaUX0RGURx/xeqXlB2gm2kQTU=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.22.0"
      "sha256-bc2NmxlezCiGOQZZfCtPe15/mZZopy/PPGX+AU0AXQI=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.22.0"
      "sha256-QxH7qrPDtaJvr9YrEEtfpK5ixHKumy7Lb5+6c4AeQAI=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.22.0"
      "sha256-Z2gnxVmetMofxmhIfVzyvxzJyfhXp0jF2W7Q+EvF88I=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.22.0"
      "sha256-+HwnGaq+khRA4F5SvpdLfbJueT3FmnKkVeIMX0E8/yg=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.22.0"
      "sha256-6vOfuTdfNGpNtH30kX29VpL0VV/kxlan6arKLpRyFik=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.22.0"
      "sha256-HPIC8b/dfvgEfuCRiQlaaBmp5Xw6NcZBeFO3z073OVw=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.22.0"
      "sha256-yaO2WnXrDD4R/tqNEi05vT290diCNbWJxKCHTh4XJaA=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.22.0"
      "sha256-NYNzSFY/X24jhfTmPg26uPC8izSShbWDO/vozC+qE3s=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.22.0"
      "sha256-q3VfX0oPqyhBfrrGLV4pIoE3Z8qdmBt21sX2WxDUR8Y=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.22.0"
      "sha256-StOesizcNOzrvqZEfsLGzL9FpFEzPqglDNmDvdm7p2Y=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.22.0"
      "sha256-BiO1lK5Z2qniLqI5bY8WNn9y9B/xAKFlPi8QhDa07vM=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.22.0"
      "sha256-6b/4naep6PYCLPugYNaTMXzfK8/r+JPoCTpqlRsQYW8=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.22.0"
      "sha256-wm9aMfrK7knPLkYWy5xOXIdGLSGfu7qWbLN2D3vojbw=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.22.0"
      "sha256-5DBwWPLRoY5hBm0EsbHfKJQR+j3n6pPBg2dcWHqh05I=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.22.0"
      "sha256-iBJabmgaQ70xHJkq0mwuemOJJ0mYJNQYM+FbMCLVit0=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.22.0"
      "sha256-QjBsWwYIxA5GAuNYM0jJv5geRXBinyiud0gXwg4I2F0=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.22.0"
      "sha256-nS4qypeSWWQ7mF68eHhAurGjUxjWg1BUG/FEnjlLXCA=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.22.0"
      "sha256-gfSkPSDY9Tyzckk7NhaQkvyHM0MlL4qKl/865AkvC/8=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.22.0"
      "sha256-CbOVLr2H/0QnCPFcR6j0ydbz63WswKz/Ugm3Aq+2+cQ=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.22.0"
      "sha256-RQlVwAenfiU0f96AfTQubeI90UqlXkoK17ebq+O7AXY=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.22.0"
      "sha256-aT0QPikVbbJP3kWmAnesvQE5rd1/uFStNYRk2gSW9cw=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.22.0"
      "sha256-a9xlkheT+4d5l3OsjLjjgF7kElkJZbemFZNTB6qrlGw=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.22.0"
      "sha256-SqC2Jl3OXi0YZE2SHNSxEgvzE99FYu/qkZDoNzLomVI=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.22.0"
      "sha256-35/PSIJBv2+69FdDQMdPLvde21JZaBuBjnLcdekpYV4=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.22.0"
      "sha256-hgWxBh7mj4szt17VrY3lGGdlyocyISJCBwusdTmjtY8=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.22.0"
      "sha256-AJFbQnR8p2t3xkSjtpIjyqjIU5BPBms4tkRrDB3BBN0=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.22.0"
      "sha256-s2w2pmQycU9TiEleW2aGccOaT8WsacAjAmC0Uh+BAX0=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.22.0"
      "sha256-kSMQwXQfaae6r9/ze2vDGYQZlvxFUkvUvgVf41oTUm8=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.22.0"
      "sha256-qrdkO5EZigoZmoybeFJSi2gDr/uGFkYnWtoX++U+XF4=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.22.0"
      "sha256-0zIOTuFVHJ1YkU+RvcH2LU5mAvxxM12OxbkGsk4j83Y=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.22.0"
      "sha256-4z1ubsdD5g3quVUa7XSsrcqV3RyTs1ScDIq7tvQjG2Y=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.22.0"
      "sha256-sjuGPy2cVvxTo776mpLoCczUx8TLtTk/fBtOMdDuxoY=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.22.0"
      "sha256-7SCHQOTOPc23edpBFnM+yKoeoLr32JcYffymetGqxVY=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.22.0"
      "sha256-4bvgk7rFP0gcJiCsfOjDfFluZHpQ/u1WYXnRBtK0Qnc=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.22.0"
      "sha256-LOD+tB5B45Ss4TOrV40ufeIQdiJqPAsuopj4XFk0huU=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.22.0"
      "sha256-HtVX9pE+vO5mdzfNXshwsmIG4E7czmd9wxvcmZgkjrs=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.22.0"
      "sha256-gJISPsXhW3YOx9JH9zRlLKcWPxoY1ixSECF2BtEZrA4=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.22.0"
      "sha256-b7AFK9DeG/rOSlfmYz/Iha/8NwDaB7yFkgd6RAwE9VQ=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.22.0"
      "sha256-kNDWS8kVjFjRnJ7SItgNAkujADhYSz56wzjHzCWuW+M=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.22.0"
      "sha256-sP9qcauhD4HoTBp8v0pe4MpdCVzoY5osFaxssXgUs6I=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.22.0"
      "sha256-Xi/OX+TDkwBp+ZKwZR3nm1mLblJprepWFyfnLRHeXKE=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.22.0"
      "sha256-w8nxv6hvKraQWA7vB7G8Spg8QLAkVQi2jrWwFlPHiGQ=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.22.0"
      "sha256-6gMJVIhvXYu1WitFgQVMw7yPxed5+L0TLhhOQkOYp4Q=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.22.0"
      "sha256-Zb/DI+zuP6LBpI4JjfNfyqDp4+Dy+xGM4tLmi78G4wg=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.22.0"
      "sha256-GSkvjf683M34NbA88IP3U1ySJV559qRqjB82EjOY9sQ=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.22.0"
      "sha256-W5TeMRYawjh53fRXsbnQQ+j5P7E7SfUTrhKtdwwb6rc=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.22.0"
      "sha256-vhJXQcpf/SM/WSIPlDsau4STczSbPKPIOHMwZMI8c2Q=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.22.0"
      "sha256-+ibKKx8EzVTA0ZTauVpZgrMATFZA84lCz7i+b01jW7w=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.22.0"
      "sha256-DAQpCQclLYIuKR0sJaX3wYV02rWAEC3opCxS6wjyf/E=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.22.0"
      "sha256-o0ODmezIE38pzs94IjwuPRvhoQTFIV2Bd+9gnAvjFxw=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.22.0"
      "sha256-jJCLogzbKKEja6eJXM4WCKNI64Ho96hjkY93dCGaUu4=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.22.0"
      "sha256-pZq8/7XxsMbi3dMRg8MWNooD59UyD0jtyXqzmkEA1ts=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.22.0"
      "sha256-/bO6rVXgRIX0wmsW8b+O1zc4xYzL9seBE/48RSLV6is=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.22.0"
      "sha256-TzgWZt1HjKdEfZ9P+wGHCnosIim2jwRhU65ooFgD3vY=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.22.0"
      "sha256-4HVA/HzeOzvoDYmbsPOLFHF8niZvNO7AaGLK07M/sT8=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.22.0"
      "sha256-IzHCHZIRwXiUfc5Ye5BWajakFh2biD4xy0cw1z1a5qE=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.22.0"
      "sha256-rRaOYZkaof6KfrC+GyGUkmSxnurnEXi1jTvkXG3gqM4=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.22.0"
      "sha256-QEYsHFSBlr2EX3hLQhwriEreVEcVjqU3vi3QKezEhho=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.22.0"
      "sha256-JSqXiS4hvYOTGoBEEhakWfcXA9ItUnG4nOWW/decu98=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.22.0"
      "sha256-MrQMLawcycrYWoZsBmhJl5slvLZ23kkYifnpmVkfUsY=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.22.0"
      "sha256-ukFN2qks+T2ZMAbTEr/IehL0RTwoyVaJQvDbnPexbM4=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.22.0"
      "sha256-rfbQTUeKLod6Y5fwFjYlvurqYbS2qBHE+39kSVW+X1o=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.22.0"
      "sha256-EXPl8FQoSiEwP5f6BysHEnJ1ntk+HPEpAsHn6Rp0fMk=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.22.0"
      "sha256-OZXX+IPHI8ikUOKgqjTS1uqzsSnZDfmtzyNH1XMdWO0=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.22.0"
      "sha256-vqwyz+oQkUqe7aC1nRrqARcqQL6SxTh9RfYLFKMPUHM=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.22.0"
      "sha256-qJLQK3QDYNWRWvK0OEN22i+hOm3RwZsO65nb0IMnNZg=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.22.0"
      "sha256-XnN4O6T/uGm3nPPHfXuTa2k0QTzT4a8uZXAkcJzWOkE=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.22.0"
      "sha256-RxJldgOekMrk6RfVuhyits0W9SKL6IAkpwdTpV63dfE=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.22.0"
      "sha256-cfbHY1Bz88j3N5s7jrys3PR5sX22EqDuJz3Vrh/dHHs=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.22.0"
      "sha256-Yr9z+JQA4Otcoxh92hc1ZdLdtrsNhvmYK2kitWme0zE=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.22.0"
      "sha256-aXQ1D3Wo4l3I5U7JIDKF1dSh5mlhw8RWhooRU3MZR1o=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.22.0"
      "sha256-IhvGAZrGpB2FX9EQDNg48tX2L9uF5SveadwiG6aXQ5M=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.22.0"
      "sha256-vdaLkWxj4nA0a+9h4wQkeM/VCP9yntAqSBkVnegMHag=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.22.0"
      "sha256-RT3fu7tb0i7hwpsyJrSLQuzXJqVzjBhRdKIUWImEYYs=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.22.0"
      "sha256-sxTEnm2d9XsoKzS6VAwqFAaGRt1sgelaJGrDdY09u/w=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.22.0"
      "sha256-dr+ugp2qtcgxkLcqw8lzjLLy0Y7Lc+9CaMmU07WER3E=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.22.0"
      "sha256-6y1vr5MfP1kou0oZfu4ltJykWRYwPaBo0f1Hwjcl8hw=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.22.0"
      "sha256-rE3aUEXfcASECVIX4ZfI4Cj/hzyjaH5s6GuT6Mm6M8A=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.22.0"
      "sha256-Uz3sAX8St/qEZffa9Ge/atDeAG+v63jcubTAY+4Qr9E=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.22.0"
      "sha256-yo9vYhkiUaVM/ZVT+nQfz8VCDPeO6eGpl93ERnHViDU=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.22.0"
      "sha256-D5R9+/UKjLO1AQK8BtuTyy+6fb8I3+8FKjVmSrx2WoU=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.22.0"
      "sha256-awcRJRDyIlI1HolDnjUkyUi2BzxIOLKgvqbssKoxVrs=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.22.0"
      "sha256-ys+/zB6ZDcpjUiF9kC25GYKFvcMrGkqfsGZMlRs01Sk=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.22.0"
      "sha256-Z+W94UHpw3f2602UEWgiJo/UUbbe3X8KNFYAFV0vAUs=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.22.0"
      "sha256-+o4xSY7GYnTiTbXPRbyktIhmjkeNukE/3ttk7yCyetA=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.22.0"
      "sha256-gXeqka6BXpj1donipn7lIog6Gw8wcoqm6yeLFhhoUf4=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.22.0"
      "sha256-tFrr4345+9zF7TK5K32rtqWL3aX8Mlj6NOhfz//3v0s=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.22.0"
      "sha256-FtCCo8R3SxlJCm2FgFtjXjZ9mW3M73i/pbOs8u+uEWw=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.22.0"
      "sha256-8AtgkUE6GDbBkjEiovFErpbfhbwYULklL20j7D3wOSo=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.22.0"
      "sha256-+4wO5mMfclRG4kiXPFXCYdfwlR+pF6HfnyhaMGURmp4=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.22.0"
      "sha256-LyUx7xj4ALJItP7Gkh+EdI2R49sbeWvi2MOrYkmA6WI=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.22.0"
      "sha256-UXG5LOKygqw1k+G4VujAmwUktFU9vIHVBTHQfmFDT3E=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.22.0"
      "sha256-uoO1mvCMMDM7g9+YsbBzTFBLh3rWwG2RXuGN4YILTHU=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.22.0"
      "sha256-KRX0KPKdtMwzqy5zwfeV0cZq1mhVYcBbULnFMJKiNhw=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.22.0"
      "sha256-bMPNUSUpxERCX2TKpY7CDzvBepZz69ZiOtw5JnsKvbg=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.22.0"
      "sha256-ezSEYExAgIuu+oIwznRBuWG5Tn/H3leQfNE0uvVRgUk=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.22.0"
      "sha256-PdrujWMg5M40qaAzqSnHm659EvMCtdm0zOVCu0euGCw=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.22.0"
      "sha256-FKWoRpJdRdB1Nm3lVZUgWPn0zmwkfjlnzwkeNJ9l2RU=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.22.0"
      "sha256-slfeI7RL7OpxwXuXt4Ojl1q4hZ14OxbGR+zaupN0D9s=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.22.0"
      "sha256-nvqWxnxNlGAm967LnSgXq2K4g1oGjt6GH/J+a8ag6Mg=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.22.0"
      "sha256-eBrx0iB/35Vtu0TrJm+DVL8YNh+5fNGORJKw6zFCokA=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.22.0"
      "sha256-OioI5ue2KCtcs4B+Zys4mw8aU/IWnKTQVb7d53uldLw=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.22.0"
      "sha256-h0WWRD9qVdt3gqqFofw5ntpjZNO9UCXANNxLoaPAm3E=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.22.0"
      "sha256-NsrOt20b+C3HOpcndfLZ9b0dr5NnhPSCzZUVW5kmzF0=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.22.0"
      "sha256-g04kdTCjOPVYkv3kj1OQO1dWQdoPjk9qUdHWWgZmiMI=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.22.0"
      "sha256-aFq2vFX121nuSyqVZU8zZikf+Vxu5s0efabb0nzAzBE=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.22.0"
      "sha256-3TK3iGXMEdfCgx6PYyj0MeRq9siER+0eFqxO5CO8ixE=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.22.0"
      "sha256-cd3Qh/ImDqLAPh58/tkBOhirzw9TMFBEILb9LzEiTtw=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.22.0"
      "sha256-SAUzM9YxQVF/qF6S/I7tMpApYnIDIY4hUPXgUPtsrsA=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.22.0"
      "sha256-VJjQATKjR6uxsIQwO17R6ptSZlJjmRUQ7i29vbOfWoM=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.22.0"
      "sha256-JmNeAIP4Qo4rXx/yiyhvfQKg9ltbxNwMLiC6JXYW8YE=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.22.0"
      "sha256-V3joMcWwiwa0nSMYlhDFPhyJb/7Gaqt76gh1nCH29bc=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.22.0"
      "sha256-wVQdln8aZbLsV1F2MIwS/G/xdJzv1vGVXITlDgubRQ4=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.22.0"
      "sha256-FfvP6OB7vBqQ5MJzRBIFm5MkmdiNkfdRFiG1gPXw/K4=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.22.0"
      "sha256-t96kYvIFtVFsrydp8PgqyN8Si7CsEZsaA+XhMwe7AUw=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.22.0"
      "sha256-9ErxKQRAIOXtEy2TbOADhvnWVqenviCoxg8zqlticOk=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.22.0"
      "sha256-M6WKLK7Azbao1K38tTZM+kCunmYq/3ZNDaO9PRjW5Oc=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.22.0"
      "sha256-swmBPOmZLlZzgdAy8Ng7lWNEjpBfJeDlOtgN3C7+L7s=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.22.0"
      "sha256-Jv0WVrAcXZoVMMH9DzNk3xIpvs0Jmp/a1khcBfSjDcQ=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.22.0"
      "sha256-dg/6/ihL07Dneo0+wFiPOFFwnAExn5rDJ+H0UhObvYQ=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.22.0"
      "sha256-wnd3S6mZbVhZMvWgHQDLP9fAgelw7nU2+jkZHGgl8xw=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.22.0"
      "sha256-IJN+zme4utrC4ngX9qZYFh1B/nZ0PDj72IVNPwfvE+g=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.22.0"
      "sha256-Lbm0thE1mpmfjhIxGUWCVu5Fpkd/360Qn5UnNNWr6Wg=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.22.0"
      "sha256-/U0qlIaQ5iZu/aO+3aUNAw1OjSxKMpm+W/2cSYpFgZY=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.22.0"
      "sha256-vYlgHXJ3mzWvPymsQThAQHw0+oeuw1xZRxKdrfT1j2E=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.22.0"
      "sha256-0u26AqP1V/MtjXqymdCjxhCABpH+Sdrqt2Ny8YnyGjo=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.22.0"
      "sha256-AnXhsF3xvub7ippcdyJdFxibXH/PaqHRvBCj2lHv0jQ=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.22.0"
      "sha256-0WB1RytK1JW+tI0AWPS/rWFfGpogWo7RtQxU7gCLPtc=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.22.0"
      "sha256-+Of4Lr7HZVzwe6b6SB/bqTmxDGWy8bi6LO4TX5cX58s=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.22.0"
      "sha256-NGB2ke/jSwydMq4deAZ2jnIorkLc7b2HAVtIffpT78E=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.22.0"
      "sha256-2hMsEsZX9dEwPVqWn43flCS2VKafdilpWBf8YfdIdSc=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.22.0"
      "sha256-n03h0T9BRYNGJPcZipFilsSZFOvUIp7/MGqohsrYfXE=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.22.0"
      "sha256-SnwKiY3Zl1ak0rB+cUZRKwmWQORC9d+CuUmBPKNtnHc=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.22.0"
      "sha256-VyhJz7j8zm6ZwQyYboF2SzHvoh3p6GnEJqeHeO01LnY=";
}
