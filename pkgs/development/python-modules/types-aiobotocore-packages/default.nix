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
    buildTypesAiobotocorePackage "accessanalyzer" "2.24.2"
      "sha256-Uc7aAJOW/G7uhDh6meNXyAlCxsOpuMY2LZpzF8sx1sw=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.24.2"
      "sha256-wfkv2Kq4w0Cr/4UbGRLYAPxH02exFtKSIQZDD0367C8=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.24.2"
      "sha256-kr/ykcIeGrNL7X0zNCYpEBK8flZJ7/w53zY41N5Wl7M=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.24.2"
      "sha256-8HRbVA8OdOdADGSiM/qcwqRqVFNtkHLw2O3UxjRdoXU=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.24.2"
      "sha256-NcXjStoCfslJvzmWxxDXlPAYxrO/GMEbzsmKQi7uaOw=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.24.2"
      "sha256-jlSLx4AwRpAhU6a/YTHf8/i8W+w7QEAIUKXAXgIiy6Y=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.24.2"
      "sha256-VGj6eivlyqpOMF6+Vj9BxNrr+cTcrtz1I3Ta3QzlU8k=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.24.2"
      "sha256-zJ8kxnGUDO7WQFnqJ3JiolgpsXB0g2eTLWRgvB+MmrI=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.24.2"
      "sha256-tcedCy72LR/rZnw8LWfLYs+Kh4GGuOj9PfVikmREgj0=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.24.2"
      "sha256-wvgMQvNAH12xf7HSTCEmz4NCPqZ7zjuF/FCCnUM5HBc=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.24.2"
      "sha256-qwjb1OM+twzJEoplHC1TAs4h6uUwShSUcI1ONe/UH8w=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.24.2"
      "sha256-MvKcniYWdhKCt0BhEhTIMdl3oIEicxSDtKqH8R6p/HU=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.24.2"
      "sha256-ouScqz5tDrS4VDrFTHJuedaqBNg8TEH3aJzKMlq4zPU=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.24.2"
      "sha256-FgOYrPPTGTwpPft6yoqUY4/gWXmbnb9IGRkjHvUjYvI=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.24.2"
      "sha256-TZAGlGG8w/AO6eiihhmVQyFb/wAtM5aOkQV2hdALo6M=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.24.2"
      "sha256-jxQX7Q6xrNLBrMBSLc8XZvPDnpE6js2Zko00iu5i4SA=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.24.2"
      "sha256-5N3c6jExJsLOlgBqhMKLROSyl6NUSCMyJPeFxZKUj9c=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.24.2"
      "sha256-bo5bRcu/NipY366EjhcRZS/9w4VBq5qA7GcduVtPugU=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.24.2"
      "sha256-UQ+K2R3wHPKnr1h9X+7nse7+sVZCFRfiGd3PvF6AOQ0=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.24.2"
      "sha256-RD8BVHNfyVhKv2dsAI6KZT0BGVklMFTmapao9pwSiy4=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.24.2"
      "sha256-UJjlQAhaNoy0SJ956XGV4PTOtNWqaxWfSJQQEqD8K6E=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.24.2"
      "sha256-JnCrfTFxA0JDAFbyLLPFLZSfWT1NWE/0/4AL7fetOLg=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.24.2"
      "sha256-VKbvEPLabwcVbl/Ru0RdF63eHcDduaPyUIn79XXdKx0=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.24.2"
      "sha256-auDK8kPp3+FmXcdfxYmF1Mj2RAUicTX3P4ycCv+EOFM=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.24.2"
      "sha256-V237GwxnJP5NbrEhXYGUzCdAU0ACoQ7gQNmssjbW6Ac=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.24.2"
      "sha256-UeCSg/FZGcG/Lz7LmjRcC26Q3KWyxp6uhQXbfp9HHJY=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.24.2"
      "sha256-ttfpiNeEn7DSBT3YLtVyAzjesfjWuv9S8H6keIqqGs4=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.24.2"
      "sha256-rMmht7tguFEeNSkTIyR+JbPE/Qg7N70880qEJJXnmj4=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.24.2"
      "sha256-fmS4ea7J0Fp1xeSEvGU1Vm97ZtXeJImmkVQ7z1IPVy0=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.24.2"
      "sha256-SeJwCUDky9HahpM9k0w3LzbUCnL12oC8NIFUNnZtHe8=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.24.2"
      "sha256-JfAVxXHodPJKVWffNXrUYuP1/q65ktbiXnJK4POC8YE=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.24.2"
      "sha256-iUu//Y8FUcpkOy0e4JfzVRuM82AEX+b+BrPZRRVpLZw=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.24.2"
      "sha256-QNIbpza8dtKXPZZeUDaDGWGflCWgUChQZsRIQaaMMoY=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.24.2"
      "sha256-Ut2hPxaLIzAXmXjpKpWsxrrBFN3Z7wAix9mIrNwynYI=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.24.2"
      "sha256-Ly01UOnq2pbCpVyI2iWTkCrp0lTmFsLbOgGGWFnRJxY=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.24.2"
      "sha256-JWM4qd0Qw+BCi3eIcwO8IDmWoQnR1qAZcJMW+dG5uW0=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.24.2"
      "sha256-UdOUp0jMf3l5CtEEsjuYEGYlnnA1qHw5nYj+yB3Djok=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.24.2"
      "sha256-Bn1jVhX4tvpb7lEuQsD3lT1SVcVUBpd41TZ0EzJFDqE=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.24.2"
      "sha256-U1gGJB5reBwdh7+VNxfnSpcWPiVqR52RawLKG0vZ5LU=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.24.2"
      "sha256-Gu6JRDjSLGcIRq+tgjTmQVlOx5TYMT4qU7qAwqM/UqQ=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.24.2"
      "sha256-UBL6uIkuQG5c/6ok5lj/8aFEvopp1F73Q1PMkk3ZQP8=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.24.2"
      "sha256-KyU4DQPDCgWyK8HlVp5Cwqvc+2NYIefz0RJcHlX9HP4=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.24.2"
      "sha256-nb7IXPGnweUKfA7Bs53VRKjqP1jPKRTALJT2bwx/R3U=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.24.2"
      "sha256-O3jzUpR+2XGFB3ddVYvpUZoquc3h6uZ8JeKnPNt4kGY=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.24.2"
      "sha256-DoVQ0D97Ifi83NB47PQffvlq/m6Kw6Amx3Isz2qOmqc=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.24.2"
      "sha256-T85g17JLCpOZ6E3xe0j0RQuQF6SKNjvthosakbGMK1E=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.24.2"
      "sha256-u8Kt67d3g4bMiTYocgAayEbDhw312n7EGW5eBh/4KlE=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.24.2"
      "sha256-3TO0pbMDVelh3t4lPQG6Alm2TFtRguYhkrCKjk+IHc4=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.24.2"
      "sha256-vyLIhLQCsvudKz8qW2Za1sGcLDOKC/i+bZafGdnsKdo=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.24.2"
      "sha256-SbTlqvcmAdpq/JTNrpzHip5fV9evqQNUoXeCIYl45uY=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.24.2"
      "sha256-O1603Tib62gwI2OjZKxG/oZRHY0OxyCi8vPKoOTYAlU=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.24.2"
      "sha256-OnitXo0mwutxrRAE+v/8UbjUZBXrJ5lCjA7Q8Xeo2nE=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.24.2"
      "sha256-WLB46B4fOCKMoODjvEG5OBlLh/W4duiYDaOsD8vOvLc=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.24.2"
      "sha256-t8V9nj24WlXDrK0042jnnO+s8JDRN6GXm/rU4D0XcTU=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.24.2"
      "sha256-pm26JANLcZD6FflTMUjOLJ16i7xNcSuyGbD3ST//jE8=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.24.2"
      "sha256-nBZFMkjzwQ5qvJqot1lhAqdGiuNrLQ/iIdTn+YwOJ/Y=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.24.2"
      "sha256-XTxYED8Bg+QkHEt6CrBP6A+meexwqtnvWW0wmebnOPY=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.24.2"
      "sha256-+6RfUNRHISompRNTUIKQ/t5fe2U8QbWKkhkvWUq4D90=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.24.2"
      "sha256-XAm+0b8CRqcqY7BSRPPAZW0il3JB+eOZgk5VLneB/nw=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.24.2"
      "sha256-pWlMGu0f7Iq98LvS7PLvp3d5TkTODJ9y9Z8biOfS12o=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.24.2"
      "sha256-iKe+nmmueHlpOM9eIZs/Rn9CM4ARm/8RVF3OyiAJ3Ks=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.24.2"
      "sha256-eEvUrd4KWX3vwgRecmh/bje3Z1Cztc70BdxSIk37E58=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.24.2"
      "sha256-s1y0FIoJ66aJqYUfBSIAs7n4gTr8jF1KxRnMZRpfXAE=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.24.2"
      "sha256-NmK/yfD4otBBRWVlsdiRKvjBazARib2Igw+/aCKOPPU=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.24.2"
      "sha256-ojgy93U6slWbbXBhZJm8jkFeAZVcpSS1ZCjR958gA94=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.24.2"
      "sha256-EsCYEhGWO/Fv6/xw6oEYiF7membA9B+GRTlqSsd4wpk=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.24.2"
      "sha256-YzapP+glU+pEdvEpMuUl7KVQIr0Pcq2omi8pfOo4Bw8=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.24.2"
      "sha256-/K5802KQg8mxE49QopLEyv06kjRxOrxulYPJBqrk5LA=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.24.2"
      "sha256-vgKn9OcPOWDPL8amA3djiLUNTXP0QDyq9d250lsGJ7c=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.24.2"
      "sha256-5dzg7xd2GRpxgbFE9o0ZDe8J46wm87Z6oFpVTvV4cnI=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.24.2"
      "sha256-CoiHfA/P9x5s7ZG7UvQ/5cPz0JiKk6X5W9gWGOQujrA=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.24.2"
      "sha256-e7thylFVxio2iInrfN3skF5CXn9m0SCJtPNgyasPfB8=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.24.2"
      "sha256-wTD00XKdHNMPe67DbyKV3ZLfFcFmh+sgAUyt6+dVyhg=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.24.2"
      "sha256-idcEfm10xXLYVLBlyN8jyKCEpuwAvWUcO4P5UNqPjBo=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.24.2"
      "sha256-+ZA0Bgw9xmC63l8aA3JUR2Qc5GLfDAt4lhAtNOoFVag=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.24.2"
      "sha256-yAMhG6AR8zcjjDpN5C/9Hjwfe/U2LEJiWPXaHN4bCdE=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.24.2"
      "sha256-SLoqYt4koIIwgfR8A1C3yuf7F1sh04EPjGebUPZh32U=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.24.2"
      "sha256-Sgq5NhzHdlgs2wAcJSfxI4KQcIuxoSGt3jnh2TmMMjM=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.24.2"
      "sha256-zDcjGpwoCQOImGVXNfvg3MJAZj1xRMupXkFQieq8v60=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.24.2"
      "sha256-PWVet5tRs/ziWkAttexCQ8j9ET6vD71FFiWMRnTaYPc=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.24.2"
      "sha256-661En00xwAZEDWuCG96Db+bMMxMrYFu1qAkRCmPD74o=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.24.2"
      "sha256-hOyR/Uv41F16Kb0P/RZ5TfLIyGsB9zxCp8PSeUYUdng=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.24.2"
      "sha256-k+N8cRLIGplcM7BrlWb2eS3R5bkZIP/yhkfXdSlteiA=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.24.2"
      "sha256-O06DEH9tzEoZYfbPyy3jesQ047otvSAumXg1jMLNvZc=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.24.2"
      "sha256-vK1ify2vQqu8R3f9tabLwaeO+J4puPgINz2lfwm8jy4=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.24.2"
      "sha256-eqeOpGaF8dKnrQzHleDmpvKgT4z4Q7BxR934oc8xB3c=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.24.2"
      "sha256-Vqb5/H7ONdzZh/GYe3FYe4Ow0wv0MVeQSjcV9GQjz8U=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.24.2"
      "sha256-KY4nvDCewVI6/paaOCVBmwuH+YikpUU9wAd+e8p1f2I=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.24.2"
      "sha256-7VYCzVsdl8X2gBmlPUDyLCU7i02/k+/lfI4yTKqkUmw=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.24.2"
      "sha256-b8bYx/7hByPRudWpwfrFgq8YQSGoWoovVQYypS3X8C0=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.24.2"
      "sha256-5A0pI0eIv7zlldJrMonB5Dch2A1w0COROA4lb62t9rk=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.24.2"
      "sha256-UH2xTTCuQOM0A2x8NxMhuS33GVs1w+PELijqnzw/vgY=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.24.2"
      "sha256-jFyO+3pZfN7Hty/wQzVzoY7dN4trO92rGz0gWrJ0mtQ=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.24.2"
      "sha256-T+JXvvm764SrlDL+3p2yYy0V5dePBDEwQNLqDVUpyGg=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.24.2"
      "sha256-ktu/hq4x/cj/JnW87IXqXJtF7l+R00BCkl68ClnLiOE=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.24.2"
      "sha256-Pbm//dPtJXjcBqZU9zgLFl2CcCF+3lbvkuCo+fpRkUk=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.24.2"
      "sha256-gxhdXqwYDs4lJSok5Z59Oi8RM4HMTwwlcmIgBnSVN+o=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.24.2"
      "sha256-bGE3YYrndf33IgvV2Hme4W2FQymrETdU+iW7jVPwkjg=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.24.2"
      "sha256-avCP4tEr2sF4oTXKEGyEg2USac+EVcPs6M0Md5+Zq6A=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.24.2"
      "sha256-agIFowMCcRcF8tKLksSjc0ZZ8mlSEbpODhRgjmihvn8=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.24.2"
      "sha256-nxujNa3pS1JnsbyiJt9g7m5u6x3dgt00rO/0ZJD4TN0=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.24.2"
      "sha256-5pcrKVd67h4yoWmVqig6NfyaLqcT/LBObkCJhqiQVko=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.24.2"
      "sha256-mcKkxYFsqOw7dZjEAMLB07TvNNbMETkcjtBcQbNfTbM=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.24.2"
      "sha256-MlNAp8YTK31j67YAGN2NjHFbE0Bl3Ayg5osrUykwn4I=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.24.2"
      "sha256-Djn0qEIW8y+9OXE7CibMg9wHhaPPkc9bo1qrakz2QMI=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.24.2"
      "sha256-xwYcNWhioWdRGMhlwSvCYXT4YDT4FJ1n/a6q7FxFWdc=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.24.2"
      "sha256-l08rv4WmHu6X3aX3SNoDDIES+IruhJz5DZivEBwFHxI=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.24.2"
      "sha256-ImXUwxSTWbjY7PQZlv8IN2t5I5B/TgSNsYDQuPIPd+Q=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.24.2"
      "sha256-4Yd9pzTHXnduEI+862BcdfDRvHyF+PZ73VdPiBRHEBc=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.24.2"
      "sha256-edmrQ+xet9pKuJe6vp+lr8C/QCSMuzAytReTV0YYZNs=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.24.2"
      "sha256-1TkRw/jIXFZcVfMlFyZkV1FcJ7nTNUUI1cy+zWjor7U=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.24.2"
      "sha256-xJJm3vczFrAMkBklsoZcsBSjUy/mDiI1ecPIATroBcw=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.24.2"
      "sha256-Tth/Un0ByMSOSyK6TtXniuxj7N4QAVLQBQrxSYKxBrA=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.24.2"
      "sha256-+YoLuW9TZza/W+Nd0tKnMfNQ16duHel1eRUq6V6Q6N0=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.24.2"
      "sha256-9dOhCYPmUAnz6WWm8oOEoyLWewD6OoE1iiEenkL1Txg=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.24.2"
      "sha256-73cxsND14OzTAH4NRxYJn/E6OYHG1hxZ8pQ7yOHq3is=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.24.2"
      "sha256-3obbkPfeB+RJeEbSiKRtMjhjX5to/u/EZ+10xTgdSQc=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.24.2"
      "sha256-5d7mng7noHGeBeGqHhZw0S1UNGytaaeu5qLskM02z4s=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.24.2"
      "sha256-nDWns0hpcDksWs2Jh/JaZW8Xup1NVpRBNSCBCSN9/ng=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.24.2"
      "sha256-zcIvEakpSUnTRoJM7Gnkobe4nv9q5qrDDFmH1vsuuzM=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.24.2"
      "sha256-iLUEdqnpK4nNJdU86P4da7Xo1HyqOiI7AfHB4gK9/p0=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.24.2"
      "sha256-D8H69rx99pYkldEM9Reipxx0alEJ1QBC3WsE4Zch6Gg=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.24.2"
      "sha256-/IkImf0n5IEuu+9z5ICg16B5FviFDLrwOhZhgz0RepU=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.24.2"
      "sha256-RAfZiA4y5VIc3txN4ur/EiFyzK78R16fOXAg+oRXN+Y=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.24.2"
      "sha256-va93iPKTRDtWrAD4ZOhlAPV62+VPwVZYIyTaXSi2R/s=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.24.2"
      "sha256-C1w31nv8uwvvm/6qy8tb1R7eUSm5/weTHHXj8bgwuI4=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.24.2"
      "sha256-yGC0u31EXD7gJPvrTD0qu1Ob026Jtn0Ks/W6n/8CNJ8=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.24.2"
      "sha256-W9tNxnHy4PPnZaoU/TVyCkTAzMSlh+gKsVcROw6yW4s=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.24.2"
      "sha256-+YoHoQGFnCWwUcWgE1uUyC49t06+X1HqI+FkQW9erbo=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.24.2"
      "sha256-Q0ULIOYW2tnhgtAICH4/4ogGlUuSniZdTYc/4DqtN1M=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.24.2"
      "sha256-hf//Zk4cfxkOiLNSF9KzekGgv8Kr7ZqfN5uoF+VHpEY=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.24.2"
      "sha256-CkBkfW6RSDsFRuCm9M050toLyxwruPXwk6eOIuvNCqU=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.24.2"
      "sha256-eamIn4c2WWG9b6IXdCCGs7YatwbFDPJ1z57M05odKIU=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.24.2"
      "sha256-tZuWtDX2yM7K+W2N6AA52CLfCZ05cwBkWQt8SYh9BnA=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.24.2"
      "sha256-AcpT3lQLTiIZI/SDOQLT5mUjmX/kpB+SOMM1a//+Hi8=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.24.2"
      "sha256-IHs8mk1h6kPVGhqqj5Bj8d1lHutm3Ogz8mhzrfzCb7k=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.24.2"
      "sha256-Ffzy5Q30Vq4sIcE2uSm8496hYbO114qbL4adhxBMEHo=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.24.2"
      "sha256-5/Xb95rUwgbDHCnkQR/lFLEu6tVvRDeS7aXXp2NvBeU=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.24.2"
      "sha256-cSWarlJrk/xF1sp9xL3OrVVTUdtr9Tvgf41O3yYZmt8=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.24.2"
      "sha256-5RwWLygCiVry5UeEdg+lXf8n3sx0l7eDwylgUl+bG6k=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.24.2"
      "sha256-lYw2xiEywKVXzFdAYFPqeL1AqwusrxBeZ/+g+7KzAOY=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.24.2"
      "sha256-97VtrmdxDCMQivIa1tTXfgfLupnsEpfA68SzlEqxaYs=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.24.2"
      "sha256-UiTY/ubA3c9vrydX6BdMvvGlq0iZ0k0s89a/48FMUdg=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.24.2"
      "sha256-axNbJh4vc9M5OJj1/cwYouFE28IVMFG4juV/tixWtjI=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.24.2"
      "sha256-r4UmPV7v6n8NzZtYB7s4jcYvpP851M9vCZlHu8E5VcM=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.24.2"
      "sha256-WJ6Nk5REaRgbqcPHmyHPEhRKkPvdzIGbp08zCa0eZ7o=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.24.2"
      "sha256-KM0c3gVKaT3ylKrGA9dn96OqPvebu65Gh/oBjFlM5tc=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.24.2"
      "sha256-4IMLV0MhvBhaRCu4D4AzMccks/V17sfgM2KaCtRC1eg=";

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
    buildTypesAiobotocorePackage "iotanalytics" "2.24.2"
      "sha256-dHv1Cgq1kAQg+ILjhsgmAmflpHaqYq9M1RWCQB2ARSA=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.24.2"
      "sha256-NpNVL021CLtbpolFFFbOL4hMAtC4owS4TkV1ULWQAwQ=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.24.2"
      "sha256-iYRdSZCrt/sKpgEuXSSd/d/CX8E0u8Hl0cczo/KhyoM=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.24.2"
      "sha256-zsI/mOQXZWgb68kj+IWuaW06YwsCFmmsiDgJ2G9T0mk=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.24.2"
      "sha256-V6HT6174p3JWZ/yqCLqL/MCBuL31+iKTxmzJRFT6q/8=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.24.2"
      "sha256-69Q9k4IyHC9hj9A7Dtc6aurPogyXcBTURfuF0e3eQUI=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.24.2"
      "sha256-+SkP8s7GUx0J055HdOp/Ea5qypUSsGXHJCrIyCvJfEw=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.24.2"
      "sha256-4s4SdzaqSiWvRypHJc+2e0VbvxyKXjhQ7qEKAdh+nYE=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.24.2"
      "sha256-JUPQao6JLT4exkOvD/JN/XSj78HOUg06rGS1D7a/OGY=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.24.2"
      "sha256-0I3ZFI8/DesRVg9z7Y1AVqk6CDyLhint9CFOUA5Q45o=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.24.2"
      "sha256-P4r7etZrrO0NJh0RC7LlJRLmQJCHXSrAczk6Li8xZuk=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.24.2"
      "sha256-LZLjkRlHfsMD3X46ihM98ZnvGTUQkWK6L5+szgJiVU4=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.24.2"
      "sha256-+ObG3jUiJO5IVZ1QG50cgoU/EiPdZMtIG4qXhBmDdtE=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.24.2"
      "sha256-CkPGGzr/FRNgwSG2blLd6jPhNjKldS7h0aeJkVAUoyo=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.24.2"
      "sha256-8LfqY0pCnyy9f79VoWYOMbdRvRNuwyhv4Msv2plL6zw=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.24.2"
      "sha256-EDxqABwkv4pV1fqv98QffGEZu+8rFFQ2tUM2M4k+wPk=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.24.2"
      "sha256-lP+7IEFvncIKtk3md3fj40mV7K7Jf0+1PfJIN36FrsI=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.24.2"
      "sha256-a7b2dGdBEOnhI9LwTuiaC4EwSgVgUNkWS2bdGK4JqTQ=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.24.2"
      "sha256-pX6wMBgj4CBWjXxCvLnqoe8TRe78YYrtXhwDnz+qxMA=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.24.2"
      "sha256-5zNAuEcjhTKIMTkRJkwmI6Ysfe+Cc8+Ha0wxcF4At2Q=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.24.2"
      "sha256-Vkrp+UK8SVwQF9ElSH0v2qe0PGhzuiJ/NBVgCJnyZCs=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.24.2"
      "sha256-PmPgTUqZ1bwo1wcQmg40AzX2wuCeq2Z1ZvAZJ15qBKk=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.24.2"
      "sha256-yW4BIH6r2iQcRemT2WrDtrv2B9Vrwp/gY0AjXXYDI4c=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.24.2"
      "sha256-COAewa+KVHdGoNtG7IxFEEXzergkmVMoiyGCkyTG62k=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.24.2"
      "sha256-LuXtYPXx6HVhvq3aVLuhhy+zYL5ai1Pp3ii2/KacgAg=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.24.2"
      "sha256-LWnunA8RUkig+/X6l7GfArakS8aLP32dLBO661MfwXA=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.24.2"
      "sha256-DE6G0mJ004rOpx5v5KwwGhnUKZZTnf52F1sMXI4DcXo=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.24.2"
      "sha256-2layyc8x5/7wn3tV8vHfduJMygGIKt3vy5phomAVQAM=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.24.2"
      "sha256-Fdcuuf3rFmmb0+3MG5jYT4UPoLXgtcd3uZnMGCu0cKo=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.24.2"
      "sha256-4TsRPgTxx1FlHSLffeYGOMeWKMCnpWHwHQiFYSfSxyE=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.24.2"
      "sha256-rs1oc1UdI8HJR/bhlkTq/PamtrSqTT6jpYRJiVynlPo=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.24.2"
      "sha256-Fzr2KrlofnUu+8YgjVMvWZfbTC8LsgRLdzxls4//AHo=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.24.2"
      "sha256-8QOhnsTOR7pIH/SyhylAN+JpkBEnATGdMlQppqUitz4=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.24.2"
      "sha256-hPUWplaONyW4rqAULA9TVVIue1th0mxMUYvu/Fi874M=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.24.2"
      "sha256-K7s9qmCeqHbARY7hk1+Fhb+9bRzxNuQxRjQQntjaPUw=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.24.2"
      "sha256-bcKcsCdnunnVfMZ2ECHOCg6AWkpkJdHoyvCYf7+Npr4=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.24.2"
      "sha256-ey9nCJt/pAJnLfJsPl2IO9gsPJwLKLAPpHsuClA+Zac=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.24.2"
      "sha256-s8RMtyfoPy1cqqaW02JIwo2T/5RD4N0slFpdU1hxXqU=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.24.2"
      "sha256-T8MG2FMRZ08rAkRysgY+f+JzS7/2pgpJA0H31iDRkjI=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.24.2"
      "sha256-UbD66HiEabAqzElfWX9gkZqLlxdUQ0ah0Cvf6rqVPFg=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.24.2"
      "sha256-MzXOrYFqYZ2CHrgmrrSnfC4UxlqFVvJ7z4c4J1pYmNA=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.24.2"
      "sha256-QXxV5SrXJrYaaT+1XBJwL+QY5r7nB5+ASJII/jz1AQk=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.24.2"
      "sha256-ZITR3jLAxcnarqOyTw2qNmcB5/n+/2mFQFSYRfdor0Y=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.24.2"
      "sha256-6+0VrYkzmtYrT06Pk5V7JigppeOf+PMG70zFaFaEVT8=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.24.2"
      "sha256-5QutHPKR0kxqNulDPdbrf31S/dnRsu5C0rSBg3NHDG8=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.24.2"
      "sha256-43jliVfhzoQmCF9eTWImal5Z9cSUspRx22npcxOsG2U=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.24.2"
      "sha256-AaHVWDpJ6IefcD0GaozfcZhoqkq2T4EZG6HyKca8dg0=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.24.2"
      "sha256-I1rmfaDPsGhij4agxvg+p/bhTDYwdcjwL6sTWcN/hYA=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.24.2"
      "sha256-cK5bnzjeOOgzj1efTOHWITFHxSpUg3oHK/3SmVWlXqk=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.24.2"
      "sha256-sVa5E4bM9534hB5RQs7HZPUm5czfEt9hfa9+9xof4RQ=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.24.2"
      "sha256-SuJZWqjuVQc6FF774h5PVHxwP/sLDuLXCtIrFgsZhjY=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.24.2"
      "sha256-H0MPnB5iuodeUbvd11/QZ7k+iYc37m+xQD4Jalk2o7g=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.24.2"
      "sha256-hk5aCtWQY32vrTPbEeiI0ur8FJOf4sbyGQ3RbGwvHmI=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.24.2"
      "sha256-kMk1O0riu7xSARJXN9o7xdbcqtjdevunuZ7YOnxhslU=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.24.2"
      "sha256-2xu7ikEIxcj0/DGaGOaOsi0qHM4FdS04jx3f3mUiAIs=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.24.2"
      "sha256-X9S0tX0YouD1FfoAZyPBMxz06M7WjXizwKQSR3U5woI=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.24.2"
      "sha256-oY7F0Dx8cUgp+SIXc+GrI158APjF2thtBURqxL9Dyxg=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.24.2"
      "sha256-Ez8R6CM88liCtQcDOqIfl4Jon8Tt7yeiWTZVjNgtDXU=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.24.2"
      "sha256-r0AE2YTCF4yTVIxwUIWeWEHjnbbeVzkWW5ja5680RTk=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.24.2"
      "sha256-HuSeuOA4xb6HWUVUzEmzulAyjRhAkFf/1QGpo1DkYmY=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.24.2"
      "sha256-gn9V+XbxwW4wE8xVsSxNiTtN27lGa1e2JFdT9IMQGA0=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.24.2"
      "sha256-CgsKRXCW7HQI1Ntw7OD3qvoOw1HMVPhpgxRqDOJ6R/0=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.24.2"
      "sha256-DI9F6W3P9HZHz9RZmJa8jNXZVlXQeidgwdgnrOf5Z0Y=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.24.2"
      "sha256-O2eAq9Jzwf6THmNWU2tHjYLMv68+DmhPYG6IDI8XKFM=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.24.2"
      "sha256-46QQE/4LReVi9/ZpzdQvLoDdIG0og/d4Jx94d4aaiM0=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.24.2"
      "sha256-DjfE9Z40ghxyfGuFLto6Ko2/4VBxrKxodvuUYQFh/Pk=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.24.2"
      "sha256-StK4zD9PE2brgEKyWQhA37s5RMYRbMeaCwhuAt5i8fw=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.24.2"
      "sha256-WXe1ZkbaUqPEkcTm41upvks97LCKH39Gt7UpGDx2Yj8=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.24.2"
      "sha256-AxPMwVTbJze/cP1wwUwBxNMLLtc2wN2D478doOi0j7c=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.24.2"
      "sha256-hSernf72v8x1ofTPF/wz1jPVw49ON+19XoFlQvuhj44=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.24.2"
      "sha256-pL1hnB4TnbHlZJLrRj4wxEJyeuQcvNAWcwiCwLloegM=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.24.2"
      "sha256-FZ2Q8hIgMNesma0dwGGYwWlDPtrcJztpLWN14sdqrV0=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.24.2"
      "sha256-rvvUi5TJvv+MIym1fmO+XEX96vOU6EkI4rs3+LpliKM=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.24.2"
      "sha256-f6R2rq5wPw5CGFXPTSJbGh8AAQob+oSxTkcOAm8LBec=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.24.2"
      "sha256-aj9FN/fsteofcpswaTZFqT6RSUYtM7WxZBrv/ixFudw=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.24.2"
      "sha256-/OuhaaITiatFCIwOvXLHxtqQUwNpebk/3CIJbNiFJkU=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.24.2"
      "sha256-6q9Fh8L1zjRM2z++CsowbIpmGBsuJBVE3QtW8xGcaIU=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.24.2"
      "sha256-+xgI7bY/GpbLdeIGgD3SiwlhIFbRLTSw8Qq1HkjmkUM=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.24.2"
      "sha256-gw49Mv9vQa7vQxbvNpdfcG6d7rZpxpRrHjzOt/plDQk=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.24.2"
      "sha256-ZRvxSMAjs17e1zhtNe119O0Zwt/nkARcTZ99WZNuzro=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.24.2"
      "sha256-iyKwi8Kx2i06PHsyhX8RFNpoIc3dero9nlrp/e22nFY=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.24.2"
      "sha256-qtsMwaB8rJvv/JnCB9lJkCtH0Db9xsoklGq3qqDRFYk=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.24.2"
      "sha256-ZeSWS+JLMwuLsb01C9nAlK309zpGI3/E5DuWBogdvIg=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.24.2"
      "sha256-nYycBLVHIXMItZXej0sgn2VE3PMkod8m2wNE1i5YDdE=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.24.2"
      "sha256-CBLrj1rh4j4FfJ+E+8QZl6O+hvkhhcAV7Rf/ppNBKcg=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.24.2"
      "sha256-/OQfwXyrx0Ko83v9BN6l8e87paLhSljqZvsR0yyW03Y=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.24.2"
      "sha256-BdoiK86wxIeKCisj+8jK9eMIPGC75n3HVgaFNroEhbY=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.24.2"
      "sha256-l4/h7OvhZHcFOggXM5nIYs/hw31cvJjnpHn8IFDHIj4=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.24.2"
      "sha256-hUo2MBhY1lVJAYoGaAVSmMio4bmiFD1AV5tzjNLBlrg=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.24.2"
      "sha256-ej/eZTLMz9GM3T4wPSMl89eKUW/HI5Q6+PXmWJB5YRM=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.24.2"
      "sha256-IoJl3XeqBHR+D2XeKd0MiRznkyNRRobW1KUTC+aTVxw=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.24.2"
      "sha256-k2qsn0gDe+tXNNttNy2gAWLWKD/gRSmdmYMB305K7ws=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.24.2"
      "sha256-U9nTKOtagDy7VsfUaBbDS779pTofn9d1Xrb2PuEzB8w=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.24.2"
      "sha256-ihbt/y+HRwrQOGtbauQVZksLHNZ5IScFai8cgZyVIJs=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.24.2"
      "sha256-FGqfkRrlRFjL7y8VbhQAWb4kfNuSfjuaSHOCuJ5hRNo=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.24.2"
      "sha256-rOL3se5O69NMWmisPeQU9NpCvsEBIWJogdw4F5Cl1Cg=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.24.2"
      "sha256-nz/wHHe0/bbflsn0gchrHhKXM72MEXiIc4Q+9BHOU9g=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.24.2"
      "sha256-VGfdqg/0n9zb1R1PHbYUwWaWuQ0o1sqtjbETk+bfczU=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.24.2"
      "sha256-4zo3haKYjZd1adFJufIqAnLc3XfYSgx6ZG1ttiURoIw=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.24.2"
      "sha256-DAi2/p2NPo7naUqOczPBDUfS5cvcaTh2UgEdbt7xpjY=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.24.2"
      "sha256-2wikSmqpfeusOoar9HG/7MCcSFfS7wSRVhsNS78X20M=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.24.2"
      "sha256-u6AZoFB6qmkf+Zkx6XFBlgr6dSKydMzs1QUAfpRJuS0=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.24.2"
      "sha256-MuF3QbKzh3RAJqvAjaUYhLkh9bQKieJtClQpXhP6FQA=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.24.2"
      "sha256-t1IGFU5fjFNLLgqNCB/ojf0rNifcbYb6ATvGoV4xdYE=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.24.2"
      "sha256-gNOZFlt+fXs2eOLrVjNq5pgsVVXAjGK+hKImnbVW6mE=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.24.2"
      "sha256-2HPbyo6yNP/KUlON11d6kUxJGclGYiWBDztWc+dDIE4=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.24.2"
      "sha256-AeiIN0AZCxV/zA/OleBKaLs8skjP/FyHbiP5XwtQg88=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.24.2"
      "sha256-MKkz1y+UH/2DqDlc7HFgGPsdTgsmh4CiHVgnQRmsOr4=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.24.2"
      "sha256-1ABS/Cd9dVBWUyxiyHC2n23a6oGfkTvmH0J8SHqp2LM=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.24.2"
      "sha256-57I1uOrzTRroD7VG9lRNxl1FSWGahGqod4VSjTH10I8=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.24.2"
      "sha256-0yGK1VPpRWk5ulvTZse8AGcWuBeqwLFd82rcOJKN6kM=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.24.2"
      "sha256-n75Fw9K9a3d+SDvQrj0EFPK/8hPRvuWRb50oS5FPb4k=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.24.2"
      "sha256-IQ4mkUHnDpn+OMBHm9a3SldrpgB2KbyfqD0KnoG88Qw=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.24.2"
      "sha256-5qefScEDO5g/zETcjCEjRc9Rx3KGptRyGrb/0V2zDGo=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.24.2"
      "sha256-GC14nlxculn+aGXVvl3Gi9nQmNzBxp6IO9EoI2fCVMM=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.24.2"
      "sha256-cnS8ylWDhe9fmAN/VHT0WDZjY0FB1G2dl4q303ypYyQ=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.24.2"
      "sha256-w7he88CqX24v+k22HpHAx1KCPjsDJrW5kO51VQ4DCDE=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.24.2"
      "sha256-4kgsEBJRe2usinaPm/j+nl688XtzsIW3mOcVjlvyPZk=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.24.2"
      "sha256-wU85s5DUzfZZj2Mm6K5qMuxXbzPFw0Ns/nrHUHx4Gh8=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.24.2"
      "sha256-pMuZtpwP/B0XalmJhAZcMc/hd5UPT39X0tTSdnFh9dE=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.24.2"
      "sha256-8QxrxAGOZxrSgLaNOqYpB1UfpEaPrQ9V+jBhEvOvHDc=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.24.2"
      "sha256-J3GJCghF9HQwhtiCYLmcbqXZOYtpojNCNzVqGTW/j1E=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.24.2"
      "sha256-7eY1kquSmH4Z89UZ2Ufsyn28ajHGjalyFM6S47cHvzg=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.24.2"
      "sha256-uBSJRkwqF89NBJ6ImofA3e8T5fj+ki6nYqBb/jAQa4E=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.24.2"
      "sha256-zaWBrhJPIhBfX7xIkkUS8WlsSRddF4+p2QIx8LjJFZw=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.24.2"
      "sha256-jcWDWcR2kbF9pG9EyCUyAEYNZeIzQaHfJDY5MB+lMa4=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.24.2"
      "sha256-zOiJpp2MuZ/IcllgTZYAh17mQPzx+BMyFJr3NVl6auM=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.24.2"
      "sha256-iJFpB6KokPPzGXD49yxNSyVkejNhzd49ncSteEfg1R0=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.24.2"
      "sha256-yXF9EEiFwjLGonHSbTBC+BnZ0exCk76/sSeIklQ1tDI=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.24.2"
      "sha256-QgWV5Kprk3UYDWocrmi52Ap4Hm+HoRRaOgKGgsT+nMQ=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.24.2"
      "sha256-SV1TXuwUfgN+G4va1wnu/rMOYW5tnkqeEeMBXV6uBkY=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.24.2"
      "sha256-4ZQKsMt4J9RWylsZs7TfIkLdTuRdac3sanT8jV+ab9s=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.24.2"
      "sha256-krCbDcKMzZNA7nXL0J/OBctbO8yh0nNW3o7nao4F1PI=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.24.2"
      "sha256-BQ7G27WFY3tpt+xWOaD8gmMjkYzkO7mifkd+CKSKSuI=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.24.2"
      "sha256-0cD04vy9SlxDinwmpZb2UOPz/Mn7NRsi6bQGdM800tY=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.24.2"
      "sha256-OYxDS4bjTVK3OwRvgZ1JV1cGD25AD9Q288V5Aav1FSA=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.24.2"
      "sha256-+uDJyXTA5WJzlwEy2qMafNNrk7Gzh2e0NH1l79Q8Qns=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.24.2"
      "sha256-HW+gBptVK2qoT1peVrjcJgJMB954IWWuE+mbriHwYmM=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.24.2"
      "sha256-JlgOpehKnxl3yQLV2OjqY4s5riJKpfPW8W7darDfhXM=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.24.2"
      "sha256-86oJDWCKkURbn/EYzzlQgrwPRygLlft7DRCs5hZhbjc=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.24.2"
      "sha256-2VFXzHMKAam29FWujUH55oGWYVI88WnF76/yVgN40+g=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.24.2"
      "sha256-ywjOF3N5hyIfzIYlOb5zbDRcWUVaQnMr2RV+3FLNXPU=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.24.2"
      "sha256-1Dj+yn1iPugGiG2reRiZQKaKABM6zWp1kSjoS+jDANY=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.24.2"
      "sha256-0Dpk8/02D7XyEP0PA48qTnUQEofHijYhfSOS7KEipwg=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.24.2"
      "sha256-nTL+9mpRTGXy/xYDfOI1PNhWT10qYOGLkCKwDzDNkw8=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.24.2"
      "sha256-oGwzbJnk5ryzauXFejj9HZyNihIKYbqF2/KAYGI5Zn4=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.24.2"
      "sha256-Uj/0ItMfwFIiCMM57yzPj/Rxt5Rwg+ST0bDTWiPeTiM=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.24.2"
      "sha256-pSYFWqTFZTBHJ3JzRju2O9kKKROLP76KL3DsnROmfWw=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.24.2"
      "sha256-PXJvb2eMt2Z8R4WXHbkoji6LCZk6IGFSRJgUE67ES7c=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.24.2"
      "sha256-IS5mYxADDlrXS8DNkhgjk6ltwbJ1w94L36iX5BHMtYg=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.24.2"
      "sha256-Zm0n+Aw4B48vFTV2S64X2hdkQ2hqj0oxcmQ9qZGj120=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.24.2"
      "sha256-L+cfr/lzUoAPfMJ7PjEt+sxicg98R5Ytmlhl3+6ieXc=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.24.2"
      "sha256-70zdjnOllUJi0lHD7HwwChC21eHA4TkvJ+RE9TzdJh8=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.24.2"
      "sha256-m6n0ibBv1Ov76spxP7LMqs27VgId2P2KhpGSL+qFzLY=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.24.2"
      "sha256-OVHNkue3xUFidNiDh4pQ9r7H2nnwaFWoF1d3li7gTj0=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.24.2"
      "sha256-FuuHtSxd/+3avj4qka2DF0hg1pPXyh6R6ywdbbYOFoA=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.24.2"
      "sha256-oWd1Zk/EboEs5mYrVmh2Uereh08K5FxO4bd1NFa61U8=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.24.2"
      "sha256-LcIfPkSdfew2u061BMlRUpVzJcWNmjFVW7oQ6Od5EUE=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.24.2"
      "sha256-aS3yAJYlhGkL+T7llRdIrtLJM1sL7ZqaqEbkQBRzT28=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.24.2"
      "sha256-Nt+2mhGMv2wHFF20mjb26WqeKU0rp0L+07/PIaqVjAE=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.24.2"
      "sha256-9yZRD/3NLu4jX4S9oloGsWvj/8moAsEomUMhAHYJBww=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.24.2"
      "sha256-cBKynyH3wCyACq4Zpgw+2kCOKIvttfWOq7B5Jbts/Xw=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.24.2"
      "sha256-lT+BmQPtf9K4QbvyS+YRo/s77NqH+omEChSZVkBiJT4=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.24.2"
      "sha256-Z8DJnCDGlEqW9f89DaNWes8zLhIVe96Zl78VCggHP+g=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.24.2"
      "sha256-lMjMem51b53yoitik+2yv+XkLAOJrUtYgDUHZn+gi1k=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.24.2"
      "sha256-PNFym3xZYP+Qca1fs00xBBkI8L+OiUvH2ruhJo16YZs=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.24.2"
      "sha256-8nE8Vx7RHMCFZ237tvWsZ6xkZ6b8EjtrH9gSu5MOrN4=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.24.2"
      "sha256-5Ilxnh1JjeF/QQ7uHhvoOPLjTzbazJS5b6OGmtbLHCc=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.24.2"
      "sha256-grProRGMfRFdSkkOiw3GQBVnDioOczsBZf+oK+m69kE=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.24.2"
      "sha256-ILg82/EqdXJilWfTlq0TwT7Arjj+sY0qWRlKpvlMrBc=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.24.2"
      "sha256-fnsqPhceAF+7UAsV9RwAIdK4mSjcy+JJ97VZeX3D0VU=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.24.2"
      "sha256-2J48HocSAXxluN4/q0A/7wAyARjxjnsc6IycbnIG5DA=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.24.2"
      "sha256-uf8upfwYqyeaemtToUdBiVWYuk53drfIzyY3DNAxlNU=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.24.2"
      "sha256-Ir+6LJ6+r5Aotmf0oCG5WRZWF3RkTZFZJfRhB3Z8g+k=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.24.2"
      "sha256-9yivTGhoXtJ1rG0ymil3SmG4V5xGmj2FGpkMnMaI7TE=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.24.2"
      "sha256-YelR8k567W2+2Bv9w24gdI0rIpP1TyssxEPIGuW16Do=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.24.2"
      "sha256-AaiFHb/3Or5BDLcNSIfXIKUF4R7eJ230/HPJdd1SWn4=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.24.2"
      "sha256-K66w3+72jZxXmamgp0PgUiD/VM9LUPIskPNQ68UTFm4=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.24.2"
      "sha256-biQpJKh3oKk5bKhaGCJr5gK63Hco3pbGT6o5oVDabms=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.24.2"
      "sha256-DVMMtkds8zwHMGpUNI5a+JVoCZQe5Odukqe0GA9U3hA=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.24.2"
      "sha256-+Kwey/y+rgaJ1EsczvY6+io72lGq9MvL6SlytJALuAM=";
}
