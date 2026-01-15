{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage (finalAttrs: {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName finalAttrs.oldStylePackages then
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
      ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    });
in
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "3.1.0"
      "sha256-SnKqFia42ri0/o/brAdL3VUpp12K4PkXZbYWgfgqQGQ=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "3.1.0"
      "sha256-ZolRgfE3DO95VB5kb3X+QfwQghAMqA28OI1R5Si1AfU=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "3.1.0"
      "sha256-xSnBT4VLIIfmvCotv3Jc7mc8xGHrkOACc+lYwzB+BBI=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "3.1.0"
      "sha256-lPQO5m++LwGP90B4G3cVeuZE7xwpMwujwFroztcaSGM=";

  types-aiobotocore-aiops =
    buildTypesAiobotocorePackage "aiops" "3.1.0"
      "sha256-urxmf+eJG0B15MwPW47z71ttiD6+GrS3KuIhGoRkByU=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "3.1.0"
      "sha256-LZ8O+yGqBzipr0EgCoaUupysB9WifuELgDCxWaasrQU=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "3.1.0"
      "sha256-KX3oRkdX03xsQxCidtzEj6IYTspLVgUoCt9L6B16iW4=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "3.1.0"
      "sha256-jaYqTV4yaND/HwjINIjMQPZOzdfFuW2HEFNQTRkAcn8=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "3.1.0"
      "sha256-nBzZC/8QB/B8RqbGgsQtuvgLWkOrUnyz3Y6cL+cvjVk=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "3.1.0"
      "sha256-FxOPaU2JFFk/f66qdoAj9GMkBTEHl3frkOzxQ2UfsMw=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "3.1.0"
      "sha256-Lhby/MfuFCmnzvp1+XDLa54PbxEpJricoSCf+HpMjeE=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "3.1.0"
      "sha256-7ozFBrfsfYfQtRh8d97yEbFubR+V3YoSBzc5HLEvj0M=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "3.1.0"
      "sha256-P4RL+zfgTFtorc5qSbE1EP9KDBER5gVaQbM8VhKsfoI=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "3.1.0"
      "sha256-vEuAdrjLMxqlhc7WMRk1xG2ZJPDFnxyQ52owqH0e/DU=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "3.1.0"
      "sha256-ciqHduyUCqUu2QdLLK4IMQWghNgE/4BG51g9zqjZ4Ek=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "3.1.0"
      "sha256-9EQKoWZR1X/FUd/hYounfg0toipUi/pUMH9tjANUzTM=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "3.1.0"
      "sha256-/WpoukvVa9AbsrgKS9XF2PiH0AjHM22J9ljWoccnTRU=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "3.1.0"
      "sha256-GKpB1MlNidGiks3qw94TcAgcCAgEQ2kwx/Br/jMWQPo=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "3.1.0"
      "sha256-CMMZt6fNdhFDmEC91FzZjgT2M32l0q8tIOmYZW9ryK0=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "3.1.0"
      "sha256-8ca8pk5tc4gDyrIR94FqYDu/Low3nsmMII/3nVU/GIg=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "3.1.0"
      "sha256-MR0dUeTAEksxJsNCCo3gOxhdc5NqWv5fv3WqR+RHHtk=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "3.1.0"
      "sha256-tAeucTehqzsisjKEo1MCaBNwcprh1DV5cjStjEpwxhw=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "3.1.0"
      "sha256-6oDYy+FEEAxCxeks1Fr+N0kRp8TKigZWjrfUQOp5580=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "3.1.0"
      "sha256-hwyN45n0KtgtxP2WblRFkirZUvzLoyqF/DW2ykT9ZOE=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "3.1.0"
      "sha256-hFXM1ERUc5XTo6KOUxUv8nYtlGrbmpxdQdSRxdOuzP4=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "3.1.0"
      "sha256-0v8dUQBkvvs8A+Z12DD3IKcKF/DjKlA6psBn62nNVIQ=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "3.1.0"
      "sha256-zBz944UhFmfTgFzyR+EcG3lhBPUCbUo2kT6Tsnhm520=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "3.1.0"
      "sha256-fKuBtlCzlC5zwEI/sHzlIxjXxZn51IIGxkTF4Yrd2SQ=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "3.1.0"
      "sha256-TWnpN/F4Kj03biJI2XY0PknrIrn2rWKJdPPj8BFXElg=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "3.1.0"
      "sha256-b96zgtEOPmRXkf+EW0gofFlnPYlrV1M7rrRoDoAB/w8=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "3.1.0"
      "sha256-zDeFTQSygwPgToHV7xsdSC0ddw50776jtVAjC82fv+M=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "3.1.0"
      "sha256-KeZ6VUfnHM858ns1JyPAst6kadqXK32bmbYP8H9+8ro=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "3.1.0"
      "sha256-ZOTS855ngmBuKJkZMmeO3jyszfmxg9CUao4t8lxl4l0=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "3.1.0"
      "sha256-SyzeNiySbo3BSaP/vdECQtDtXLN+KQHKPWu/MeWUbZQ=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "3.1.0"
      "sha256-zS1JTSqFZ67sl2PCRABYUZr82pqeAg+KyaYEYvUG5bc=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "3.1.0"
      "sha256-K3eT0TLMuzD3PToEcaIbX+hXyl+FORf+MWSlsX60dz4=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "3.1.0"
      "sha256-9bnpFgiZrVc7cAhDKK8iticHM6s26n9IDl5dh5sEU3Q=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "3.1.0"
      "sha256-8i4+zpAyWCGollFTCnN6H/8UEh1Pru/6uDNHpy5JMG8=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "3.1.0"
      "sha256-UUjb2NYc2FHCUWAVdZV/SCvh7w7RuQe+5yxoRkj29o8=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "3.1.0"
      "sha256-hVfjddO1GQV2Ua4PiwcfWxpWaqKZUjzt7nP0yKoeVxg=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "3.1.0"
      "sha256-od9QHD9v1xuARI/Qnrfj/yLbMPsfjNxZQS7x/8ilv/c=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "3.1.0"
      "sha256-CfHyOA0WPr5p3daBzpxmf5rjoalIZpz7nYDtPsK0SOM=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "3.1.0"
      "sha256-A0sqtiNEB78yXWnODpeY+UME50PvYKOxom1iHwRFhzw=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "3.1.0"
      "sha256-Rhz/8Vt+jzYH4HzVyqxTGGdK50EA+PJxvYD8D5IY4zg=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "3.1.0"
      "sha256-STVOEHpmJVwanbh0uDJx3IKS5wnkYzUoft5gO87psyc=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "3.1.0"
      "sha256-LFcc7Bo4BQpUmChEdI8RgxKHnTgbN9UjovjUWwoPgws=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "3.1.0"
      "sha256-9hhzyG6EpTohqtlUV2IfmXJLjJVoN11ysfGJ+5L5rUY=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "3.1.0"
      "sha256-27i3uZdRoaulJNggeuGpdxRBEKCheKmIeWTslQpPjzg=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "3.1.0"
      "sha256-ZMZruxkE8SkgfkALJog07893ZeGtChObyeCa2GqYt2A=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "3.1.0"
      "sha256-O6LPr6cobe2YUzdnVjFtT7huWnTnvBYZmMMvBf+5qzE=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "3.1.0"
      "sha256-TWakgguuFp/QoA1nai7i2HARRIW5NQ896G//XuKeAIg=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "3.1.0"
      "sha256-cb6KZC63XQ5S1YVD+QvJvdpQTCtb+h80j3BwGcwT+GY=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "3.1.0"
      "sha256-zHbMVVpqoIVZERLZCvcifbQV4d3p4GsjC0jTFuFO+Gg=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "3.1.0"
      "sha256-Na1qrwaZnUa2ykkSxzuJ/YDKRb9HvTCSwQ4yDqmzC7w=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "3.1.0"
      "sha256-7ij8U6VviPnkqKI2ze9c7xr93zASo4STLwsK0Hg1UJQ=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "3.1.0"
      "sha256-s1smeDMBgTv13Z1xd4Y8aAdDAnk3uejE8f9jrO4OMws=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "3.1.0"
      "sha256-fPfFd6zH60L2yJb4CKZrPrdXvMcVInh086OKDb83AVs=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "3.1.0"
      "sha256-CFby6jm6OvRvHlx3jJpHzW7vhTOQwtvOs0JRsrDfQ3E=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "3.1.0"
      "sha256-5d4yFCjGiewzuKoLudGry2JtGZRoWFWQr29NDDtzSEg=";

  types-aiobotocore-codeconnections =
    buildTypesAiobotocorePackage "codeconnections" "3.1.0"
      "sha256-pRBUBkrRrJNx+8Y3NBCSh6nuj2GnoCofprQQ30+R+5E=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "3.1.0"
      "sha256-xyHRJEMt6mdQ4qYn8v+6aNURjZnbK6+fU5kfbffN81k=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "3.1.0"
      "sha256-pdmiKHGbkh/0fnc6eferb+osI3HswwsGBbkp6UXFsjE=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "3.1.0"
      "sha256-26ML8kz8aJv+z0jJRgVMYUCeFYqnAICXL5RLDwP/fu0=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "3.1.0"
      "sha256-uhiOzIynzAIw1a3gwlYbZdhxgZ0PAQqIFOzfe6jcpfQ=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "3.1.0"
      "sha256-MFp8D7NbUHj7L/kHk015YH/JbnH8fknd9RIdSrJzUvM=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "3.1.0"
      "sha256-8Xj4pcs/lTZISAn5aL3eAxc8cW5cizoyyiWrclWpqg0=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "3.1.0"
      "sha256-zkKJ/LHVBVlRoHrRAwdIm2cXZztPExk9syX1Tk21cWc=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "3.1.0"
      "sha256-tHVu2D61J9Pm1T6a4ldGDIL2V86jEZ0HpJqERTOvYGA=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "3.1.0"
      "sha256-tVys/AwUF2N3Vuf2C0kKbumlhLgMj4jygm3Fc0IAnk8=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "3.1.0"
      "sha256-jlzuJYgjLdV5iGa54kFrnULqtoeeb5akF8DbD7CxX9U=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "3.1.0"
      "sha256-R+kdcgMcDfcw19obexApEU962LUFP1fpqhyhlvNP8wM=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "3.1.0"
      "sha256-dIQ1DE0FMKB77F/SjrtvTpFlMAs8Xr+/WU8tYtkClVc=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "3.1.0"
      "sha256-N2jCwYvTA19kWDYA02DqxbyjzOK+x6DaxULdqATFBMU=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "3.1.0"
      "sha256-y+ogDo8M2i0FitiN+mLWP9zr6tGI9E0xCyiChWmOFRc=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "3.1.0"
      "sha256-UJmCNh4ztSFjUcBjWq6X6snkDMvnv0OkM02644bGuKM=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "3.1.0"
      "sha256-e8RDq/XYFPpDfiROvwKTL5/MlQJGQZ8iop2TBBw30/M=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "3.1.0"
      "sha256-VuRNxaoC8X7/A1z9ZsGI1LuS/jF2QD70Tg/x6up2Asg=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "3.1.0"
      "sha256-FXxX0c9bUcfNCf60+XRu45yrCg89CYDM1dl/LKJ1qNw=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "3.1.0"
      "sha256-8sI2YWjPQ5PK98bKPbOtyVAu/qwE0RlWXyw9DkvJxq4=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "3.1.0"
      "sha256-8Gj7Xn7NNVWrOrAvJC2ZvIzSj41PaPANGdChiPEU63s=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "3.1.0"
      "sha256-FGpxvgjp+ecyGSBs65agxgjU6yVZggX0OJIJpAP1JZc=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "3.1.0"
      "sha256-bzFl8MnHhyudMluiIT1M4dBJ/3Jzj5juSfze+k3X/WA=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "3.1.0"
      "sha256-+tlJD9hJEbHOGa+IRE5+m+Q8hrhuxgY/KQfsksmySCs=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "3.1.0"
      "sha256-g9YLo8u7wrDQrkxMq3qBxBYp90nL5q2SC7g2klZ58RQ=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "3.1.0"
      "sha256-KSmlaEg0QeaYcSuygCdUdQPSMSZtPF+Dj6tLX9/NfVQ=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "3.1.0"
      "sha256-rk2Y6ORfBxvB9gJdL63pOKfGRedjfTgLmLQ+wsETtLU=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "3.1.0"
      "sha256-nTp8MRw2ANhPB0ZCYW6H06Hc/uJPuIvBxnoiwzqs2nU=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "3.1.0"
      "sha256-f0oUcBtG5+glLmxgvbH+9UkSfb6A978aSlMgJpdpxqE=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "3.1.0"
      "sha256-6zchJRVMRLm/8rdbbdbZlNaudWeFfB+TsxF2mEzkdAc=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "3.1.0"
      "sha256-Zkj/ADjTZ7rN1QH25o1V75WSjjH2vpcjKVLXwm1RJoU=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "3.1.0"
      "sha256-5BqP2umdlTCUlSGMCXhmoXteeFFcQJCmZjdYB8OIbE8=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "3.1.0"
      "sha256-JPUZmkF7G4wE7EFIzMX1LsoRlsNpTHaq/Ggyv+PKwMI=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "3.1.0"
      "sha256-cPotgvOaaxly3F5V9hTtie5SFPpTI8N9suZ1TQMdyHk=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "3.1.0"
      "sha256-f1W91AbQbFsFarn56Kdhm7HUlKTcrsTtu7UF/TUyBOE=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "3.1.0"
      "sha256-7PQ2sn7Zsc4EpUgRiJeAFvW3lCKBI+4ch/ll8ZQFTj8=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "3.1.0"
      "sha256-cmQMdk5K7S6Mde4PHDaojg/OeOig8x/oeLss+A6ei+Q=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "3.1.0"
      "sha256-8j8+C21wwXk+9sFe3J8DbhPwpU4F2Q1SSvFh4EptmoU=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "3.1.0"
      "sha256-/6F8DZLlmy7zzBQv+xEZVBOx/rd2K24fdWYGWd6xKxo=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "3.1.0"
      "sha256-qIhUifLN9+6WZ32q+78vx4BrlLACwOxp7mr83RclfQw=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "3.1.0"
      "sha256-LBTFbluPB6oRfNMRd9cjIoSqugELYcHh0j/U8k7PFXE=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "3.1.0"
      "sha256-mOjHGyKLvQQVR1QiRphNNKUlM/JxmkhrmDB6dPCctKk=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "3.1.0"
      "sha256-Y+Pga2FPVCVmtS45AJUW8Spmf7nFnpkKXRLnXPy5+Z4=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "3.1.0"
      "sha256-zlKO6VfDhqtdxhGAElcM4ftgTRQtCpjSX+SSmadxfcs=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "3.1.0"
      "sha256-RTEpkAPlVCZ32uSOBQmaCMpUWSy2xlHxshp89rmkAos=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "3.1.0"
      "sha256-MTTEDIf7P3hTMsX5E0NQR2dTnJcro82wjvcNmIEJVhA=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "3.1.0"
      "sha256-NrNmlTC5oScqUTqmqx6lqQ6wrTMe+r13U4hkOOQ/BS8=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "3.1.0"
      "sha256-ylR4Pt4N2THMQo1IYiJDQ7OYVZ2ITRCa5midn3qSEbk=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "3.1.0"
      "sha256-py3ar7ItRIt4YYUzZ5kDir86bMFuZ6A6dp0bC4G2CtY=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "3.1.0"
      "sha256-RpBhzdHX4dvVqGAQrAC4isCCb5Cq/aL2yDyo+ZGnZgc=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "3.1.0"
      "sha256-EpmemrOjq5mWf9o50lCXViu4llHanKZvb/A8YgVnCiM=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "3.1.0"
      "sha256-KpoKETGtBjVJKhDirL84rhzbtsoQg3gwS7xobQ9TgxY=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "3.1.0"
      "sha256-SxyUq1zC6kkMUBrGJbzGYxWwvGqB3ANW0JtQd/jxtHY=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "3.1.0"
      "sha256-gubklXJInU0GCKX7acnDYdGsVgmoIMFiO/UttBrqpdk=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "3.1.0"
      "sha256-5XdGe5IwnCCp4UAMfG7Xs4fAErGOF5SGCWjzTM65fuk=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "3.1.0"
      "sha256-iuVI3zNUOp0KkZL/esjUizIXm6dv+1F4qvPEpCt+q74=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "3.1.0"
      "sha256-pJQf9U1/8GrgxtuMUyEEhF0PyekyZcdabyFwJEKHG7U=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "3.1.0"
      "sha256-XXZmmVOlAfKLYaNQNZspEYa1y4srrbZIlcSDvKN36HI=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "3.1.0"
      "sha256-caybasvmM7Pwamr4af8R97wpq5vyBaLt4L56j2Flg9o=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "3.1.0"
      "sha256-Sp9YcK21TRpXvwcIdcYLKgR3Qg3GTa5t9ejh/HIOx5s=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "3.1.0"
      "sha256-daWdU5Z/r7zn8C2GAo/D27lbgXx8+HSk6KMHb4Auox4=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "3.1.0"
      "sha256-l6Y7+QRkSp0XuIe/0PlmdlkSzyLvC8ZCSY0KVF3nR1Q=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "3.1.0"
      "sha256-IxgFimf776J6LP8GxoQYaZTNyq0Ffjx4UktQzFUDxAQ=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "3.1.0"
      "sha256-togK9obwZmeRfyk2H8do1lR0GFC8pdrSbpSPScjZIH8=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "3.1.0"
      "sha256-RwbXQT6XimACuY27KzVuaitF3iE3Dj9mHjdAmS45vq8=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "3.1.0"
      "sha256-wPMjnB1f4cG+/j8Nkz4eWlanKeVf71UoBppA0tlD/a4=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "3.1.0"
      "sha256-ocjhxiAOLVNd4lC9h+LFfq2D1tJrAFcSOWKJKBFd76o=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "3.1.0"
      "sha256-rOVLedwegZI8xLr77v1UMJuNgD/YcFzWQhmZtvIjrLY=";

  types-aiobotocore-freetier =
    buildTypesAiobotocorePackage "freetier" "3.1.0"
      "sha256-wK8N1rM0GBAjAU7FIHG/3vtnGzafY5PZSyMqIvClygc=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "3.1.0"
      "sha256-BvxEEIOMXIlIPF7bN9vaIiUQKj5akIOGHC1TYdIud9I=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "3.1.0"
      "sha256-Aqcd7XTOEN1bsSUDOVTvInu+tNJH3fC5KN9vLyz+XcU=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "3.1.0"
      "sha256-x/tkjPYfskX6VPdR/d/EWsR0t5gW8EFQ9tUFhP9i9Ig=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "3.1.0"
      "sha256-yRAxgkKNxUombreheyCWtUFWI94llDbPNkwpeUdkgDU=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "3.1.0"
      "sha256-etiEIv9IUi8JchO4jQCJhwckmW34+A0i6H4bngkD9zo=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "3.1.0"
      "sha256-hZl7A0xHL4QDpspXeE8iLxPNARh50J32VHeFQJ2by/A=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "3.1.0"
      "sha256-64dQn2EF5Rpg4IvLY9cJiRAdR8p2Iy4yR7IG8ia1gNc=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "3.1.0"
      "sha256-RIOsfOpFMJq63u31kHlPcv+yOoG7gV+T/yOkq+4OPTs=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "3.1.0"
      "sha256-5z5+UUfgU+k7vj/m8oP1ArFLD/kaiHUn7hg7bvB1voc=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "3.1.0"
      "sha256-PQCIo9iXtIcUnRuIqER/9umUfuo3ZdNvilwk1Ul/Vo4=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "3.1.0"
      "sha256-hQZa+IJ17KAW74lvr/SgFBp8PcxxDj/AlqMD2c1npvo=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "3.1.0"
      "sha256-Dr7bjcCTyDPq+H5oSLrnScna+ed9fAlILsIloNcSg6g=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "3.1.0"
      "sha256-oO1Z1Wi+yaFYFv8QRazan7K3nphZ+8Yi/0pOKzAeFyc=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "3.1.0"
      "sha256-kTCWYpsrYdubY6YP4pUZT6cOvIX6YRuwrixE5wT+PKE=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "3.1.0"
      "sha256-ZsCGymvDPkesYqbGEQJSNPs0o63pZTdw4CyJjM7cnN4=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "3.1.0"
      "sha256-WFJdKT9iMyN/jtjpdl/WsoPg7ZPbgNs3cFY8NRratc4=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "3.1.0"
      "sha256-UHm7UXyxu2AGwRajkzjva/gf5Zt018QGwVYHd7oDsH0=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "3.1.0"
      "sha256-7t7tHdr2YjDmfgmD6hLTyHfN3kMZ/Qz5YY+kNhZS4Ng=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "3.1.0"
      "sha256-ZbbLKdo8PqsUjEwr+itVW/b7MwYamz7WMxA2sPfp7E4=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "3.1.0"
      "sha256-Nu/pk82rKYFUqLdu6v12KyPE+8i+RVhzP4IWvYvv/YA=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "3.1.0"
      "sha256-G82AQCjNmpHHb/4YHaWo2SYz1dnaVjoeT5H11LLgVac=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "3.1.0"
      "sha256-GzidUjaNI8Ge8OeKfOTXVhiI45V83S1+KDNLzBuXugY=";

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
    buildTypesAiobotocorePackage "iotanalytics" "3.1.0"
      "sha256-bjEz1fPVRVbH+n+yP5IWlMRhlRzEjlTOaLEZgDQBoik=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "3.1.0"
      "sha256-LCmas6ZoGVJCBGTbDomlUZ9D8ObHlKLfAjQr237Efvc=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "3.1.0"
      "sha256-qNBkkdxY+HPRWPnwMorXbxJ7zOAEAnHqxZQtI8QcC+A=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "3.1.0"
      "sha256-6Fc5977kR40OBCUUuwIeTB69AmGMauxbBlnNEK7kRe4=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "3.1.0"
      "sha256-08+rNo6tbxufgP6OevGF2we6k0yDAI1D+m8cT721G2I=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "3.1.0"
      "sha256-BWHPwqwKLjmbEoI4plqT1AdwUXMI8i8NOmJcoBzmxLw=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "3.1.0"
      "sha256-g/Jq1mr2Yxj7JlX0sJNKZHfpSKHIxl3th0LkKgP+YSo=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "3.1.0"
      "sha256-+QPdt5r0menJccR41IUgFzcylBFZhmd5R/DpHEiaof0=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "3.1.0"
      "sha256-IkxNyeMDLOOV3PQyLVmspjXfeEZdz08ZBfRRBhOTDxI=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "3.1.0"
      "sha256-l4fDC3LUKsjSRfvDeF40mhr1NBDq0J5F+OslASDGnS4=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "3.1.0"
      "sha256-D32L2RCf3R4pUue6GrlT2sKAB+85QqE7gGfXDZjD5Wc=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "3.1.0"
      "sha256-i2szlIDUNa+Mv4p4Gk30wPdTYE2dxMYB9P5sQXApm6w=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "3.1.0"
      "sha256-umf4msLS7tMsec5V7pVT+iOPhmrEssg/z9Z9aSdd3ik=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "3.1.0"
      "sha256-xZW5MjR8sEba1Df99mKkq1eya52C8vR6f5AAE+WADVs=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "3.1.0"
      "sha256-ZDbiinME85jauxx0drBIkcrTZRIoHpH8wNu5alFesWg=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "3.1.0"
      "sha256-kp7RCWiIsfyqnEErjfbV9X4/0VpBuG0MYOAdAFCpVkc=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "3.1.0"
      "sha256-M1ZO2zbwgaSB9y5OdIStKiDRphKc1uNNJAADFR7RVJ8=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "3.1.0"
      "sha256-VmZcaPS/FPi7t0PqRV1HE1chtApLrcgyQMK0cjKy8Fo=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "3.1.0"
      "sha256-EeeNZd0b0czoQSYrYwlDH6eEDr/sT+y9MWtQfV4y4p4=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "3.1.0"
      "sha256-nvkshYoZlA9Sz54N6GDusXpWSlBhDIeMHC6ouk3lOK8=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "3.1.0"
      "sha256-ZEz80X8Dvl8IqB0YBDtKCxzIviN2/B+VEE5DnuNTDo4=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "3.1.0"
      "sha256-9lU21OHqi5RZVeMEXfnddSL0O9uF/3h9xgOcpvWprCA=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "3.1.0"
      "sha256-/I3tJnRe1Zzm2NNaUe3sRlMl/wn2Coz0HGwD0YlpL90=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "3.1.0"
      "sha256-c/p6NCoccZetvwIq5SLXqAgNIx15IBQhx4nLWcxjNgo=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "3.1.0"
      "sha256-j5roaWr6aUZJfTq0JcZtfQ7j/garPW5OmHYWzRsSx/I=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "3.1.0"
      "sha256-Uh7xa6fpE21HfQuULq8EhR/QyzEqIaIocwxLcXX6HSQ=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "3.1.0"
      "sha256-7Nsh4AZqSTmnUE8AyXYsZULq8352kvLOBYxTI2EYTtA=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "3.1.0"
      "sha256-NwH0MoQYvspI5Tws1kO8Y8VlPvI8lS4R/1IWgHLxcIU=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "3.1.0"
      "sha256-8G5vD6/ZJXyUfwg5j4lCOyK7MfUUSZ7zzG/kVxHFesU=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "3.1.0"
      "sha256-TGQ/T917fF5y1xdIyMgNc6Beg32IW/Mc/omxg4OD41Y=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "3.1.0"
      "sha256-rjtfFVw51IfcOib/UWoDm+Vl0e3TAdV+8DKORjWkgOQ=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "3.1.0"
      "sha256-3H4Hs7eSua0xfbwDqzoAPEgaHb7CaPTqKX2AIykPAX0=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "3.1.0"
      "sha256-naUBpkzd+0yDdj/0pX1HsfWSHWPufPI0VlN3oEcSqkE=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "3.1.0"
      "sha256-XIxZ5S2STuZoxCRElFuR0CBw0qbZFdsWcLgP9p0eAsI=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "3.1.0"
      "sha256-lxbTkemBfXZdnvcqDH34SO3CrD73P4tuskeNPA4EKF8=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "3.1.0"
      "sha256-nXLQhq6P9/zYlPNPgGUD3uVbPU0FyjdLm2uJyeme7QY=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "3.1.0"
      "sha256-QStE+H5UmYQutURBMmnBYXtzhk2XPJ48C8o6ft1kO1w=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "3.1.0"
      "sha256-cRg85uugDASyPt2nvE4LJxRSv+0tVfCwdFu3WiitTSk=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "3.1.0"
      "sha256-TABnp9dbK0lFGfEKNhVrWXgNtjoQ1Hue3EeHMPPlGcs=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "3.1.0"
      "sha256-MtoPx73eNTczWKYre5MGsjPhFFqyrf/7CxKr5vURobw=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "3.1.0"
      "sha256-3BlyGJzxaJJmtvVPDO1Yz9l5iv0Tq/ZzD01AIEcinvk=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "3.1.0"
      "sha256-VNcDoCskBwlQP8McYe1oWLoTaEOmTZqRKwiS10hmp2c=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "3.1.0"
      "sha256-LsoDa6NENLo9PhHomtgQi7u9OsO0hT2reP2wKQeGrCY=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "3.1.0"
      "sha256-n1Tm0b89leOqIP5W8SFfSNUp7Bcmsk7iG5qzWnJdg9I=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "3.1.0"
      "sha256-0VI3i04F3GEHQ2oEGdY4u8sCdS4C6GpVxuT5oXWlEUQ=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "3.1.0"
      "sha256-WVQefI929zHBU7YPIoms1w89H6FSlb0pqYDrV/s8aZ0=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "3.1.0"
      "sha256-pptb05jWc1EaeJLyAPzNV4lUCm8WLNs3fmV1wzY4FSM=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "3.1.0"
      "sha256-e7kFjbuO1ZtoexdLH/h/8H9axhjXxg0+UZYBtx8ZjGg=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "3.1.0"
      "sha256-vVKPKcq0Tclv20DSYF16lHlDPlYbkZjcW5l96BpuO2E=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "3.1.0"
      "sha256-VpS9XsH3pkM+MtIvkqSVupbmY/SOYqavmJv37A2C6RU=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "3.1.0"
      "sha256-/LuKnEz9ljJ9Od3urau/v47HzlxUH2/Rxw/2Z8Lpx34=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "3.1.0"
      "sha256-T1dhrkPx7i5WsXqFy+Vjy84AqXqpqcGwJ8vuRyCh8Bk=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "3.1.0"
      "sha256-2yFnBjTn7pmuZMeQtOP+h62nAkBwEnVmTgXPXRQHB4w=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "3.1.0"
      "sha256-8O0u2Twrzmcmd9NvCY0Lu/CIIHt5TdnjweEde0zq5qE=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "3.1.0"
      "sha256-2d/8v1dOyH2i7/xBoIjVlfOHi4w36K3SQVPAcPWNHSY=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "3.1.0"
      "sha256-vpNAWfHRQfLpL/nQQDB+keQzx8W3Gzxf2mBQeY55bb4=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "3.1.0"
      "sha256-QlhYhGg8mdTYzJYKCLYCBMI9fm6bWLnlCfiU1Z8UPvI=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "3.1.0"
      "sha256-cYGRsNi8Qz8MqDlYREcwBDn6XeOEKNzpkrbw5R2Txo8=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "3.1.0"
      "sha256-twMmwL6aCrv3qIgUY3TvQvc2+NIl+VisAEqkte8+Y8I=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "3.1.0"
      "sha256-5ZBnj2vC8JLvG/fsfNhZLzFASNmZVXecTcXx56yJd5Y=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "3.1.0"
      "sha256-Pa+0Mo1M9592t9jypMgWXPtaVV5ixIlbpvdlqoIn9aA=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "3.1.0"
      "sha256-E+Ewmb0THUfQalvwavdsjbI9gBxt5jjACyGj8yd54M8=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "3.1.0"
      "sha256-mUH/rO1M52yctoTlxshMKZzicBR6lYk+gQBaIBj+F4g=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "3.1.0"
      "sha256-N09rn/l7RaBbxvDx9sOhNLoNrsYaSKwNOfBGUOqXhj8=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "3.1.0"
      "sha256-ASpM+eVGpsH/lZ4smCKPbPSVzYLbu0Wvd1fjsHB+B5Y=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "3.1.0"
      "sha256-vp3acdzrz3urnV8MMMCDWhfIsqsqVPr3pfmdwvUEMxs=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "3.1.0"
      "sha256-SVpO6Zcaz41z+0C4jkcjrX8pwAgk84rzQnH4zaHswOg=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "3.1.0"
      "sha256-u4qzwYEtyy0Xm+Um2j05XSXzmhwkhCaPypwgQziz8zA=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "3.1.0"
      "sha256-mexMmERO/M5/ijNqbrcYMhZ3KkssA/bkdqm/jIOAlXc=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "3.1.0"
      "sha256-c4oSY8KD1hmuBF9k7Y1PolF+J/KWDDep3YOdfDuX7d8=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "3.1.0"
      "sha256-uZ9jzqH2GqMOu7semwQUfK+QNnS1Lmr4WtOLsH0uhvU=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "3.1.0"
      "sha256-4QKUo+nfhOp0B193Is05Uj0IRvub1iTWXJsyxdkEzZ4=";

  types-aiobotocore-networkmonitor =
    buildTypesAiobotocorePackage "networkmonitor" "3.1.0"
      "sha256-KcRWF8w12mTQaJLfxpnIu6gVMGHogUvMVDEaltEkUNY=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "3.1.0"
      "sha256-pWEdPF2++l+NugmxUOl+vXnF1NyPb5tRhQ3j7L8A+MQ=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "3.1.0"
      "sha256-ZTA29UXlf8werkHgRjj3lxqdifgaGuL/f6HWWu0J3PI=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "3.1.0"
      "sha256-AJoeYNXxBoKHY4s/AlSph0k6mit8e4tv0z7JepKaDm4=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "3.1.0"
      "sha256-WXax0ReUKl+Z7SBtPVXqFIVKFPjVsta9xc+WBoy3c8A=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "3.1.0"
      "sha256-BaiRDt1tXIPgb1sG8++4KO9USp0IQSHSGSHs8x8e3yc=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "3.1.0"
      "sha256-AdgPazMDqkFJGNvBKL9sZkjEfbE7OgvxABTHo3ZfkzE=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "3.1.0"
      "sha256-+eHT5wowQ7Hhh/hknShSrJNQOeN1lbPWo95SHLz40Fk=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "3.1.0"
      "sha256-rvEI2jLRCYQXvb3UrZQrDsL1fWvfWUIdnekHaUiY28Y=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "3.1.0"
      "sha256-AqPcpmfoK5b1+urB5sMevuThOHfaG4JACzxcsaL5ez0=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "3.1.0"
      "sha256-rnfe82cPLd9VxxS+ycLQN3+b/nBRSwVvUSBCJ4fXVPg=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "3.1.0"
      "sha256-XoWj+MgsCgrpgPEvbGQdvZNWrah4a4YE/B8ZnPNyf48=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "3.1.0"
      "sha256-cZtWQx0dsHBwfdgW0IV5vvf7T48QgjDwneapLelh8Mw=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "3.1.0"
      "sha256-quupJC7lp19zGepwF3AE7vC+RQK3V0ZEZ28UERHLqTQ=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "3.1.0"
      "sha256-YhDayVTPYXTwQLIi9/x6RLOJvO/8mHQRijjgfEh1Uu0=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "3.1.0"
      "sha256-Yu2TwfQg+z67aYVmOmE4MkHQYe/L7G8pscSN7Ex501I=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "3.1.0"
      "sha256-sYA0knUpk6BJ1OalXZUqlMbVwdFxf52df5uIXe3WMHs=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "3.1.0"
      "sha256-c2W34nrI8LSN+4/WqOD0D/GedYYFB/pttSLwH8wTd38=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "3.1.0"
      "sha256-6sfSZTgDInj8uq7su9HRtGXNXAODZjk8C3dyEjIFBUI=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "3.1.0"
      "sha256-M8gwIKw5i0g7MmBP/3Q9qGZNdy+4M2y7PkaH/r28aOU=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "3.1.0"
      "sha256-sD/cb+Vlx5GEVJBw7cSdEdVfxG8d1rxtpRl8bKjTNko=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "3.1.0"
      "sha256-5+buKscamnXMnrbDKmG4+CLZX9JFsZFUwq7a/6bn8Dc=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "3.1.0"
      "sha256-xL5nFUcqZXWyzKVcE8ZPO4UlGdAQLUnsQWQIxOG8nOc=";

  types-aiobotocore-qapps =
    buildTypesAiobotocorePackage "qapps" "3.1.0"
      "sha256-z5neAo+Dicr6ofYAxojuy38gj3HY2vRYAWDFbjHB8MM=";

  types-aiobotocore-qbusiness =
    buildTypesAiobotocorePackage "qbusiness" "3.1.0"
      "sha256-FmVK+smTLqJxVR0XcB90UVFF0wqsvp5IRaEsvH05QC8=";

  types-aiobotocore-qconnect =
    buildTypesAiobotocorePackage "qconnect" "3.1.0"
      "sha256-bud5qpY9mB1LKaD/GL00l+fDYg6TX3XKuWdz3h2e9q8=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "3.1.0"
      "sha256-w5a9S3n2y4wVoS19FcLlnS5SqFbqEBr8e67ZdhL0URs=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "3.1.0"
      "sha256-dfXZMZd0W4uQP5YuC2yILkUcZkRPGLnARilQJ9KdF5I=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "3.1.0"
      "sha256-8nReCqY8ZQLDEPLxSLwOktDv1FQYS4tg4ipiniVCxTc=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "3.1.0"
      "sha256-5MG19K69uAeyji6VLimgCCmnikSXDNfW0vbT0AuZhuo=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "3.1.0"
      "sha256-OTR/lyVHXTHL0p2MkrnlQ0EzNUlmBETU2Qx/t0OSOu0=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "3.1.0"
      "sha256-Qih8LF6U/b8TdKoYVkdCUP23CQGykQrs+QYGnpj1UeI=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "3.1.0"
      "sha256-lSaAmGax7v3PjY6TomhzUzkYR4hPphaFaM/nkKcIKPA=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "3.1.0"
      "sha256-948QWRNkfWACgji4YLYg8WjMcR+hQvLchPVA3YNkhU0=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "3.1.0"
      "sha256-BpZz/7EKGeX4cOpw1ytdKEaNcZM1RyNnKoOM1vMkNi4=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "3.1.0"
      "sha256-/Wjl0M3HztmSHQwshi5tV1qYIpF1VfWjfmHLG/dk60Q=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "3.1.0"
      "sha256-JgadeqkL5Vtlq+zqbVF6KxwyziOwyGxcaVdWro2WgdU=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "3.1.0"
      "sha256-7XeIQnK4CnIEOEcuN5WRVgEOd5dhXn2uKGWHOrR6aps=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "3.1.0"
      "sha256-wrfCRdioYGv9AnyAqVfMQC2kiA6ZLBwUx1ekotzhl9Q=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "3.1.0"
      "sha256-ceFD+jZ0iEOj72AewYaRwFkDaSH2sREnM+DT4PcxBho=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "3.1.0"
      "sha256-ghRcEZjAGk3Pgt2s5RPV0JkR3aTr6TAl89Gyeg4FXaE=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "3.1.0"
      "sha256-W2DHYrs86MuFJWu4PbTgsote0A5XapRIOV/j6+FmY2k=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "3.1.0"
      "sha256-st/GM/SDGdCAppeAGt1JtzChSZB+zuJs3vgPTdqrRB4=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "3.1.0"
      "sha256-xx5ZF0r/iTknhUDQR0FG3PO5rXZDdMx5rHMJkzORR2U=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "3.1.0"
      "sha256-gQB/NxwpU4uAs/E1zPhJk0Bk31RIVoI2aViDc1b42ME=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "3.1.0"
      "sha256-JBt104A4GY8m/5D0o7qkUAro5KSSOIPcJ7lPI07kK0I=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "3.1.0"
      "sha256-WiokR/bIrIo1hn8dNEUE39jdQGfn1HWmJXL9RABq1pU=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "3.1.0"
      "sha256-L2HS94X8utmvKgGzFitQQ2+VvqVEDgubhI5vYKI6NgI=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "3.1.0"
      "sha256-lXcYqT86772piF3ISaa3BuH+0dWQAYlZx/qByaMGTGA=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "3.1.0"
      "sha256-HAmUUdGgifi3+s42DG3jJRF/cBaN47T+BXYf6/M8dlc=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "3.1.0"
      "sha256-zv7RoHPhzWDLts10yAzNQfBVVhLRki+4BIfecs/JNHo=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "3.1.0"
      "sha256-bczUpdMqOV2E9spSecN4A+y6xwICt+Loi5qWGuk03eg=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "3.1.0"
      "sha256-eEPDFJ/F94wug/dy5OSGtsRFLy3IIfF13nY04PQVvOo=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "3.1.0"
      "sha256-L4cYdBMAFloSbRfeBB7NLzPyOrvg/Vdj1dsPnSfuWqQ=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "3.1.0"
      "sha256-WT0cEANNO1LOliCXGge91d2n2pRvyV2Tly3Pb21qk10=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "3.1.0"
      "sha256-toHkh8rk6zc8Rh5CSUlqCve9OXLBMdlwPDwt6xHX9QU=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "3.1.0"
      "sha256-wY8/GXv2nND1CTAlYqBSFxXPby5L9g5kct2JEAPidSk=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "3.1.0"
      "sha256-DMdY/RDKlVHwSZF9UqlBqBy5ykaCIDby/9Xt7YuPoOU=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "3.1.0"
      "sha256-5xTCsRu0U8IsGhdHyOcvYEHERWsQi1fagkQbT9x13fM=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "3.1.0"
      "sha256-ajFLukh8J8ThSqzAezavRh9BmzHD172I/SPIGrdaEXs=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "3.1.0"
      "sha256-IUogq2YP8NS2j2YvZvDq5ksvuhjQHXPkWaOSEbPx9JY=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "3.1.0"
      "sha256-w0Lheu2ToNzNnlAMu5ZPxZRBSLXprQx0A7qvc+oBtuE=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "3.1.0"
      "sha256-4VXpWU074BEUIXGLnBdLs1m5DPvIaPLMWN+/xxXmjwo=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "3.1.0"
      "sha256-oGuB2qtFhIhnC5NmVq/KSrpxx+03istsGnxvY9F3cJ0=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "3.1.0"
      "sha256-orzycME0BtGlLShK5X7Ql483G4vjws7t/gYaQQIKg60=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "3.1.0"
      "sha256-Ekn49/PK4UF8VWImSHpekTunFCsl/YRQ1MB4AQZXMMk=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "3.1.0"
      "sha256-y7jJ2imuARj32pQixnC7tKf6IWq82vPl/HEf/cf35x8=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "3.1.0"
      "sha256-OmhH8U7yTwaX6581Py8UuDTzBtJJUkke7Z4/Zm0NK7w=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "3.1.0"
      "sha256-/0+oiJTBv5W3PNKFENeYH+h2VDLG4YlFXUURrPLaW3I=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "3.1.0"
      "sha256-IQDOahz+4la1BUVy8reXMW3fIjNA1l60HJHKZ6w4QG8=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "3.1.0"
      "sha256-qYXdjqq1iXBy4EDOYVsmbAzwogWhVBhC9uRI1KiVquM=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "3.1.0"
      "sha256-JiEXlZXqNQ+GO4YhSzCdWTr9MKroHxY1Ph96Lr+pswY=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "3.1.0"
      "sha256-eYoLfpd7b6VOrsr+T7tk4VvFz1vCOZXEfv+bbwDTey8=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "3.1.0"
      "sha256-grFoshoPpEgSc6T8wr81CVinis2B3iz9qvFs0r92j38=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "3.1.0"
      "sha256-EAnE5LKWvXy9dzcbeSxPzrYsG1TA0OTBDHJzpEKS4pw=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "3.1.0"
      "sha256-IOGFSUqGCb+KqngPJOqB+DMyEuD0wtv8xo+1DoN8jF0=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "3.1.0"
      "sha256-v2hfm/ul2rXT/2R3jiF6EdzsMaPZImMpAicGAAjzjrc=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "3.1.0"
      "sha256-Z7FzWQ/UbNow1MRuXXb84Lcjw+sEfPYnAMPeoX6acUQ=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "3.1.0"
      "sha256-Ulq96z2XtIdSznx4Gqqhcx1EV7dC3Z4Ld0OWWxHqpog=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "3.1.0"
      "sha256-BuwAGJeZx1Fddj5PxXBrTGzp1sKvJoKN2KYINeGjYH4=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "3.1.0"
      "sha256-6s3ry5BnGjM/sBe0W4KmC+Ip+XvSBWHAK4Xf0rFvKe0=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "3.1.0"
      "sha256-gtqeQxwDBqUbdWpd3UjxYFHQmH+5H8Aqo1tv60S24Lk=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "3.1.0"
      "sha256-Jglxyt6yRGmqYVfyQPVhwXkd4Ow/kcD5wFcvm3ZpMUs=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "3.1.0"
      "sha256-b4tCC6RfEsRfjRwrj/7lN6d5XAP+2D0/pcKoa0Fn6dw=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "3.1.0"
      "sha256-H5abKfILHzK44mCrR9+NLD6dUcekKzaJyKplReQ6Mbk=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "3.1.0"
      "sha256-VBtpZ4RaoqP6nX3wtid2r/9G/ipaweHFDCKi6gqWm/U=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "3.1.0"
      "sha256-KC/y64DyxMTU6K8rOjyQ19aD0f7yIxagYw5lGJfFABg=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "3.1.0"
      "sha256-ScSWdT8LyPvR2+RA57zvzSRjaOhJCtRdXNa/1Tntilw=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "3.1.0"
      "sha256-zILXejpMRNFOZf7uo1zN7LNMQx53iBQ1fRre/CqhoaI=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "3.1.0"
      "sha256-cebQ8VKsts72NYnKkW8h98LWzFT+kryML+QixPcrbIM=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "3.1.0"
      "sha256-r/GK2RvK8elLpGam/viKMTwwMzjsB33u7ltlxekKs+c=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "3.1.0"
      "sha256-E/xxsSQJYBaw7gREQXxk9QViF8vAf5t2R1z0tly8tWc=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "3.1.0"
      "sha256-vxNTxg73/WoQlKYlRYFyB4HH/YozsOozPS0K5ljDyC8=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "3.1.0"
      "sha256-sg60b2M1AaOHJzIHKlg6oSn7/8IK6MrNOo5bzS7wT0s=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "3.1.0"
      "sha256-v++hWoVWkQWaCqkNOM7rLUm7vVZo8G8pMJ6goFk0ZCA=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "3.1.0"
      "sha256-LMelnKaE+c+DvHDPcYDLdfHGXWX87pUUsVCzBTck/QI=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "3.1.0"
      "sha256-N2EjWkLEY+wOdjDTNel0ei9/K+AOUFkIikn/7kZwXIU=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "3.1.0"
      "sha256-rN+xxR3h/hcdZ/8VMk8fjTNHQf0sxb7PaEblRWStozc=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "3.1.0"
      "sha256-0VpeIJLbTR21fR0mMbyPUU3ARz+upyigK3JgyaTeP5g=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "3.1.0"
      "sha256-K0O0054UcfCREojvO7DNbZiKi9EvYecAr+7S+0+L9bM=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "3.1.0"
      "sha256-P7YQ8aBwuVTMGu6QGLwTXzb+geiu+hIIeF7OsCJQz64=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "3.1.0"
      "sha256-uYCvXx2e5r9PYZAZ9/CG601DhpfPDiCYqw7atmG5utM=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "3.1.0"
      "sha256-wnda/0cbBkGfCyv4RZZ3i9Y+hv5Fy/WejbIMMwq28rs=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "3.1.0"
      "sha256-aXv6bZH5MlIftMbVMdxACuYrXOCk0VlAobsV46koQ9k=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "3.1.0"
      "sha256-eZfpwyDlqBPOGwfk79DXYxK4WGo6aPuEz47i74CGj9M=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "3.1.0"
      "sha256-l1v+uTaJSKXWAQFPJRUlIwLOaRcVjyiHwLuVIsnQ/kk=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "3.1.0"
      "sha256-TAneDz7z0QnrJhw42949pCsfJqmTk4VA6XRRNveS60M=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "3.1.0"
      "sha256-DDgNhrFrkdUwoi2Xe3KC/kM8uhU1Onr9G6yJMf+00QI=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "3.1.0"
      "sha256-kHWDLWzdtuVltROd01xBjgm69aZvweIl4VWts5lvryI=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "3.1.0"
      "sha256-nYhS8E398cQZKF0kPhfUGUfizChzt7ge1MU+E6wMKi8=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "3.1.0"
      "sha256-8w6AikYLb51DSMMwnqYhHNupCENq/xnHzpIap+X7SF8=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "3.1.0"
      "sha256-8O190iIan75SlrnrztiqVjQTKk52YSTSWXj9GfgK9hk=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "3.1.0"
      "sha256-rGDjXz1mt2wIWcKylK/OAIRW3JVqQ+VhSJZxhYnGsbo=";
}
