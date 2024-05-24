{
  lib,
  stdenv,
  aiobotocore,
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
      src = fetchPypi {
        pname = "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };
      build-system = [ setuptools ];
      dependencies = [
        aiobotocore
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
    buildTypesAiobotocorePackage "accessanalyzer" "2.13.0"
      "sha256-2rGRzXYKK3p9OCb0navkEMfhOD5KHkn8wcBPL1LaNSw=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.13.0"
      "sha256-AZFkiL11ITJ7BqrQ2n6O36KZTkEnHfWPgCfrNujkSUM=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.13.0"
      "sha256-3ix+COBwfB2vw9SZdg4VWTll8xnJHklVHGxzETuARIk=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.13.0"
      "sha256-ZnVAvkJfc0T4bjEA2nCXz3HRkqYc25Y/J+1+rs5BP3s=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.13.0"
      "sha256-WTFXRsPvia7R7E0E1eUj70j+0gfSz7357jW8rRtjF4M=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.13.0"
      "sha256-aTDO+xerXkn8pXEaaP5AMjIxN5WfHjsrwhg+mywYshM=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.13.0"
      "sha256-SjPzrFsewsxhtFZ9I+M8TdogzhIHZ5+EQDezOKjxjzI=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.13.0"
      "sha256-X7rXIFPTWoLSH8qeEr82lasrMWmMxIcvf54GqFhrBuI=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.13.0"
      "sha256-MeO+lzOoycmkMyYRo5oGv38imF3FxE3PqldSByd80IM=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.13.0"
      "sha256-nzo28vBn5eB6DTBJd0MKqnWglnVnFvTctK6AvdUUIl4=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.13.0"
      "sha256-09iYkY/l9OlvJ8G6t2RDjidefo7xRcCNvHXwNuct+eM=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.13.0"
      "sha256-LcRjuQxaVqSaBL2o5zZSwJcFvWpnJppGWrodhxVTylw=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.13.0"
      "sha256-GdNvsp/kLjvbk0AXe81RU0OpOy8rNtsYbUCzzsbNqak=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.13.0"
      "sha256-Zjrdq4psuqLpx5Dfc+jFz1bJjr6aN/lw4cxdrP1FxYc=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.13.0"
      "sha256-3FzQHi9zHeIOw+4VC+4ad+tcgqHkIOnVbwLIDOX29qY=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.13.0"
      "sha256-w8A+hrPeNSIHHcybIYHX3Yv14eAsJeVE5oQaRlqC7cc=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.13.0"
      "sha256-dY3cmGpEBK0IR6A32rv3rQlA0HPRVEQ38uRF1tVHpkE=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.13.0"
      "sha256-rMjqSqhjIVRwDGWuMh/l42R40HDH/YNO61GJecPS8ns=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.13.0"
      "sha256-bwkDaXZzvzs+o1xc7Iw49Q/OkDqgGkERsmc5mg5cDGU=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.13.0"
      "sha256-Q8EH1n2JyREf6C16pa1aaI3G12OtUODcRtffVq4T/kI=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.13.0"
      "sha256-jUYqurcU2DLVlWwEglTQciaukFTv27k54AuuROfcySE=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.13.0"
      "sha256-Zlt7YYpOwMDM3QKu0w+dbdQ+hyEVY7LiZmAj6pwAbpA=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.13.0"
      "sha256-8/BY5YO5fpICY/sr65eNlask8ndV2XvywOlx2OrtHyI=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.13.0"
      "sha256-ekiWpPFp19h60dcWlDh4kDxwKGHMQnGktqf79lyKRl8=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.13.0"
      "sha256-fgYlxpwdOFJJT3M7KL3ZptXAA3Kh5bqI49dlpDTqb/c=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.13.0"
      "sha256-KSB1DTKg4lqffLOznLbWVkoyJzlzY4vBY/yDs5iU4Zw=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.13.0"
      "sha256-TJ7kUw4+I4ULd0C6h1jPxSXcdQdKVCex4kCKDaoh4VA=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.13.0"
      "sha256-gwrLUcGcLzrHUcr2IC00n5AARmomcplngo4Wen/KLSI=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.13.0"
      "sha256-zvzQxpvc9BLRhyEFJuGy+eWXBp164g4GNK0h6MlmOus=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.13.0"
      "sha256-aEb7RKPyB2bqBY0stzW4pQs7bxo/p2k48/+L5C5YGzg=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.13.0"
      "sha256-pbtnM1AriZtRP/HJc41dDlobc3xSsTfTp/zJocuKlg8=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.13.0"
      "sha256-xF44RthHgDDS5ByOypisgNuc+WEMVNrv5HLGzYR9JYE=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.13.0"
      "sha256-HrvVOyhXIyyYeWOUGd7/j8Tzl3jTLntxxjvy/Mc7wrE=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.13.0"
      "sha256-xz4ufUY8jlYNfM3s+v1eKTfwd4kNILHyc/R2RnDomJ0=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.13.0"
      "sha256-v5BUWy2kn0FCu3Megiz14zRNMz5FA8sU70JAseQ+ta4=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.13.0"
      "sha256-77yNiBRXsIHdzq0l3OuDcpgLP+Os8fQ0BHD2mbG6318=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.13.0"
      "sha256-XNCLUW6nzzZjyvHCaaIJ/T4gTM8N+442xCeL8XBNTsI=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.13.0"
      "sha256-qbOkIqemaH4TCqW2/6gYTyfPOlwHyRPLmz5f88HI+b0=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.13.0"
      "sha256-TVZRLx8lI0yZN6nOtdq3WhF6OkUFMWGTp25351JTE5E=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.13.0"
      "sha256-48fjMzUahQ7P4cC0b5JG8czayHNAWuVvgD6v7/LTkjU=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.13.0"
      "sha256-lxDHSs3VxWJ4Evu9msY3f9rWb+Fm8yrrsZy8usMu4vE=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.13.0"
      "sha256-AVUVMbvgYxkc8ksqwoFTyjxUbb79Yl4577Scavnj0Cs=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.13.0"
      "sha256-AYixLXRtXT24h3mFOQ2cWfTLNbXQHmGPnx/VZ7IK4ow=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.13.0"
      "sha256-FBRfBadhpoAcLMgAe7hAJbTtjgPRPSlJESuDZPriGv0=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.13.0"
      "sha256-ELw+jWSGWPeQJNiv18908fodXCKE8/sJ0/wzOgkixuA=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.13.0"
      "sha256-8s+cGZ339c8Xf/AGFR6Y6Fsdz1pOW3KlYKAuo1e12Ss=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.13.0"
      "sha256-9uGsmz+S8Te3/hOZoIZIqLg0EG3Mz/fM1k8LWSe4rLY=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.13.0"
      "sha256-/uqAAVrtejrLdZEFrDhK84nhhr8An4Ha2O6HbcnfPL0=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.13.0"
      "sha256-/QZuBKPxLDmZXB15Mlia4nKhVpDniavrHbjsdtg+61g=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.13.0"
      "sha256-TJ8gYpQgqtIJv6COksxKzv0QvlMrnGJF6+vclKxkONM=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.13.0"
      "sha256-wzMsnA1GbS8VIc0wCL9hWdsYV/ygCYmorBzEjbQbhTc=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.13.0"
      "sha256-2XXac5p2UGkczHqR0h3Nf8Q6pAcfML3b9pMwEXwz2XM=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.13.0"
      "sha256-VcJu3TW7Ha8VBZoJSH3owe6ufCSoIYQqfOfEg1Trx5Y=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.13.0"
      "sha256-BPWVovVZAd/sif+YTkGM/WpOoJp6uwpUMeKmGFd/LGg=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.13.0"
      "sha256-kNaKAn54V5xhQv1faxjrhChZ7icBAJJZTqibSdwYTk4=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.13.0"
      "sha256-myGVjxJ/1CvAt913JQXE9/7pGW8anI4F2JrEX7lgaOQ=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.13.0"
      "sha256-gCJYgtZcErsh6e/dupRxG2tDdau4wB9nT+HJdRgI6gc=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.13.0"
      "sha256-rcJSBY35FT2aG91rsZqxS3QwYkP9MBfCQLAgR8ZZ60g=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.13.0"
      "sha256-pjVsGz/wmxwm3r1a5M9oMqRYACXpzsBJZR62GFQKw9Q=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.13.0"
      "sha256-t+ZK1nVpuAEzTzokBQ+HDd9pbRNv/Z+AsYA+3+nHKLE=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.13.0"
      "sha256-Or5a/BiJnYMvXDZvCRJ59GsvYr8Um/ziypVohwarFYg=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.13.0"
      "sha256-UZHJByboBKeyGYF6SfdFzcuZKAUOyK8Uh92cdQ4Z36g=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.13.0"
      "sha256-9ewkKGfQeeIPLYsgiq3RI2f8Q+g1/QFaqTvcqpXtPt8=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.0"
      "sha256-nvkAGHA2VL7tGHz/VZiWHKRcHDN87eDq8js127VlZMk=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.13.0"
      "sha256-huStUWVW5h9PPm4k0IjZoS7mBXYEf1nuc/BbYASjJYo=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.13.0"
      "sha256-9Amvc3yj1khFTLpYsqUGPlTRCjbW3J9Y7Htr9gkSEAQ=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.13.0"
      "sha256-Vr+ZB3RAWOdioDoKn6O8LCQGqM67x+3Yvq6DvYjwbSQ=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.13.0"
      "sha256-ryZ+wZ3acevXf3gIZV37Lb2t5LGtz6RVrKok6OUYt7Q=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.13.0"
      "sha256-XnAF9Zz+BslG+teKTgWVKqBKxv159gJqRVvP3fF2BU4=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.13.0"
      "sha256-NzcktZnXaylZ0OzDWQV9r7G+Yk/QJvqApcBOggk5yg4=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.13.0"
      "sha256-cn1rch5FwLmFJPM5G8YmKzRuZ5VEyB1vkapOeSg0QEA=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.13.0"
      "sha256-e+WsU3fcS7Al+IEibaxaM7lYFFHJNEaW2ULd37wA17o=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.13.0"
      "sha256-wWrYX1uqUkHegLr3bjyP3TZjBst6+dCMEpK1lXVnMo0=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.13.0"
      "sha256-OfnncqMXbS7bH7VqKlvMNuj4ixmoli3MlDxrMq1Zmj0=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.13.0"
      "sha256-PEOGQ3/cMA2JxN87CyJx4FeuY2l6YP9ZMsVlZQuVnOI=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.13.0"
      "sha256-pdEDzu2cBdsdDZ9MBkuXXXouIWLczlnQLLLrJ2ZrdvE=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.13.0"
      "sha256-7HQAZPgHTGNmE3cZKsPE3Q1FSD1DOpxhmgx7k2VvRfI=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.13.0"
      "sha256-mxTtpPu8ejJhwBUqpIJld9tQgx2+KdZDCWLxgz3KIbI=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.13.0"
      "sha256-BpX2KPUIEzev3J59SjXr2+87So9AYcPP4NqqqYxg7nM=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.13.0"
      "sha256-R23tUBiFw3XIwd5dPEKosq+JjOcaan4mefgrnb/tnZ4=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.13.0"
      "sha256-g52TkGMLMtLZceDfPEuT/+A/uiVdqnZODxzJUwihin0=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.13.0"
      "sha256-Gejx2MwkOofstb/goBp0C9qSWcpLW2E5Fgn46VAtK0w=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.13.0"
      "sha256-fQzxx8jCPu4/TdtNrOQITAEFGzyPccCNK6diQu/4Imo=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.13.0"
      "sha256-GTh5tb9BwtM2zNvAQ47DvwlbgwNhOuL9Vofq3MVJ7ic=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.13.0"
      "sha256-wdInWu2P70+17ir7mpBK/qO7+sT5bp/lKIkOQwfk3tk=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.13.0"
      "sha256-qFfp+vOsmY43ipbENzgzQXBoNnTQ+jFXyxe9QL7y58c=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.13.0"
      "sha256-K9ofKUFMP3qY86xRNgpjZen6R1gOcvVZ0ry9A7geTKQ=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.13.0"
      "sha256-hfqMkbY/VKpx9Ew0Li9eCiBN17LK/UOZWYpoAZ2IaQo=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.13.0"
      "sha256-nQv5dFtxEwm1PJExUdId8LOXF/stNBIg96wgJJb+nYQ=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.13.0"
      "sha256-Gc5vGyASaYsEqYRGX9fbIuOYNVKzdjFYXd20U1Wo8BM=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.13.0"
      "sha256-Hjq8egh2iPANaq4LehzVS/kMX/Uh0/S7YFFPDuTA+N4=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.13.0"
      "sha256-fS4Y28YisR0C3MQWQsBwCfKfqaffZCbHu6sZZeao/ds=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.13.0"
      "sha256-BzWDZW/196ajDFw47jOZyTJPcZkAHKgzMYU4NmKeyUg=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.13.0"
      "sha256-oTf+KiNaXrDYdMCZMF+O/tAPmsybWldtT86WhnreN20=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.13.0"
      "sha256-xK+ixxVGf6Hr/NJGu4k4vlq8V5cpSPViHKsfjusQaKY=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.13.0"
      "sha256-v/h5WFjIR51RjwCn02abRfo8fu+tnncldVPd71xJt7s=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.13.0"
      "sha256-Em0eoBCYM0HmkJBgVJKsEyLZDhVu2zW9OKZ5TEQ1xEE=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.13.0"
      "sha256-AXclEe7W1pqC8JVsOY9afICCUT7lIcwR7De0JMuPbSM=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.13.0"
      "sha256-QETi2ToYBF8UQq1+aNW3ZaNEI+haQTQq76yes/U/dpk=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.13.0"
      "sha256-Oftnt6MpThaa3USfEGZeAvx0pCiY0vQImtNWVwk3ACs=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.13.0"
      "sha256-GvUGSs/nQTL3VJpVsFx9mAI9nBx+gnk6yhwRfTpSiSk=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.13.0"
      "sha256-P3kqtbGfUKRCJzZqPjg5DpuUADyo9OQvBzqX+e6eoZw=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.13.0"
      "sha256-Qv3/a0zCZZ7HSH/egZeRBb+8QnWWVIq4FI+UnA/l7Ls=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.13.0"
      "sha256-yKGswYQKMKkagsVI9Kxae04Xrdrn8dXZSy0BkQ6RzG0=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.13.0"
      "sha256-6Bc80WQMAmA8LzLEC/ADFz1kc7oRQLYb7YZH8FOfmVs=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.13.0"
      "sha256-NIB1DC4qaMXEwrDOHcnRAifKUH0LouzyKlCd7448PZk=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.13.0"
      "sha256-isdFNO1MOrx3O9l4DWjUN/GmfJk2PnprHrAfeaLDkgA=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.13.0"
      "sha256-886NH6Lg6mLHdVCRqZ/c+z1DgQ6Yy5DYX7Gd9kf3lMg=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.13.0"
      "sha256-8vm8VQENdxdjhMEg7I9SyQX//LLnKE++SvIRhyCgb7Q=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.13.0"
      "sha256-L8/0MxGvGLTfwrNSPyYVtfz46TXJVPn+0pBGPs+SwGo=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.13.0"
      "sha256-UiN9U4WpqgBs8fCcteUTz7bzwFBwJV7mpOMvEZIy7r8=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.13.0"
      "sha256-ok+Ystctf+09dxI2Q+lXeucckPQZSJSyx6fbPsYgOn4=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.13.0"
      "sha256-e8UsYdshyUhdyGxo6ZNhYMw3H5MyL2NjZ6IVDoJN1/0=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.13.0"
      "sha256-k+/+TC9m2v7t9O+etubXMGrD1FJ2Ul2eGYf2MwPYDyc=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.13.0"
      "sha256-LFmBCNyHEG5j0oK3waIrVQd1KeE7sd50JdD5J+rjxX4=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.13.0"
      "sha256-Y0LOqCJs15OO+n3vmIi0g2DU3DLzus1lvZXQU1FjDVI=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.13.0"
      "sha256-L1y4kgUBTQx4DfFP9/Yegz0T8I5Qcvv6Ll99NFCuC0Q=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.13.0"
      "sha256-N1u90rw2M4Sr6CQgB3tXBAmXX/Qu5jG8QHfRn4gmxxU=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.13.0"
      "sha256-3E01v7MvD0NC5QXMG7zQ1m66sa9oo6VAzVqMwQaUQ04=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.13.0"
      "sha256-KDJlHpf+95/H7axc65nY2XNTtxSUox2iAG2SQkRw600=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.13.0"
      "sha256-or5hhp/ZxYw5DN6LUpAqcR/2bDmRppT1a/9L0+mRcSA=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.13.0"
      "sha256-80Y0tP4x+fWeJg+zaS/c3TxYflD8Hto7vNNuDqApRrg=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.13.0"
      "sha256-Wtz55HZjmJwAcZhhuGGq4U+LGg+/xfADcXXCtgNVpGQ=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.13.0"
      "sha256-8O3BKG+R6CL7CSYWcxPrKfcsJGkSoIbI0DTOXLzS2/Q=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.13.0"
      "sha256-lUo54nWEsFMcNDC7rpBFc3VhNjafUax1Utc76BWd/bM=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.13.0"
      "sha256-LB2Ms4okxEMMOEwMd8/JykfnzmsOKRsSOF92UAlI+Kw=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.13.0"
      "sha256-atPLPwuCkYDv3vyYQuj9+2VkLx4tL0q5/S8g24oapSY=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.13.0"
      "sha256-2XZkPccKpLYIXNKhIRuheJVnAOLr2f8mya/vuefX0d4=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.13.0"
      "sha256-Sxhfg/weC3nSRYdT2BnPiL1zzHMtXV0X0iDar2LQFiY=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.13.0"
      "sha256-UowdjQc9yaP5Y9XCcynACAUrHJzFZXeeCRWT8NvSLhs=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.13.0"
      "sha256-lJNVoAMtqdFmzFX9RKmVoW0Ww0EGRWFrB4HpD8EL7i8=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.13.0"
      "sha256-vYJcni53gQDsns8fPNQTsbSIu2pKlfHOi+Y6ZBsIlrQ=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.13.0"
      "sha256-lpk9u8K+XKTHa/U0y42B6WJ/LMH9Sftp958PbwTeJiE=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.13.0"
      "sha256-mnCvxOER/AasPUVwwfLl/jYsb/HgU6n2nJs5vtCgD0Y=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.13.0"
      "sha256-pEBpwnQBOwzbr76xdEggj9Nrp7aPJjRHGV0lpU45GDY=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.13.0"
      "sha256-PiioTpD0PMyQStz7C4PP7/jPhCFGPGAJmV6tEroM8TE=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.13.0"
      "sha256-doSLPlEx0bEJHGMPDSUXWRmuJwdfiOaDCxkd32kFU/Y=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.13.0"
      "sha256-HyptnMArByCpLsFRTZWFHIptEaPLujUiyGHDUshW+3w=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.13.0"
      "sha256-o+AKZJnVXd/MDaP0Ws2ImRHmudPJkmJIinNtE1HLX90=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.13.0"
      "sha256-whj5Wf3XLhhzJz0pH9ewMrrReI+8UiVmnuU9oi+0KRM=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.13.0"
      "sha256-zT6k0pAwR3ActVWyUsE5blqv78xHuQGQlJKvjqI06Os=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.13.0"
      "sha256-rmrC8PXW1KyrZo0T2pA9bsHCGSR3DIPYP827jCPR7Ao=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.13.0"
      "sha256-rP9XtYKaG8sCSeF0HTGCLofTIbg0iyCjozqUAwQvOFk=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.13.0"
      "sha256-iZHJ4C/Ai7cSnWQsUsb9D1eMr8+17XQr+okJkb6KquM=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.13.0"
      "sha256-uVr5nzXn9/OlJgcGckH6Qi5eOWULyhwBbDehHxMHk60=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.13.0"
      "sha256-BENRjvjKgd9fy4zt1LXqcDhUhK/OJG5FyIaSRl+NnPA=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.13.0"
      "sha256-bhC316GPUqjSpmrsyZAZgCHcPGubEBXqXsueTnXaAOg=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.13.0"
      "sha256-xXYong7il5S1cjAJUJe1d4gSkn+6c/eBe7FIjEmNYl4=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.13.0"
      "sha256-bQah1T+GlZryFRE8Z7vpNUEVJmXjCX05GWYR5Y8KANk=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.13.0"
      "sha256-0lWhcUjZ4R8etiKugTuELzpbF/7+7rfbAsXAmB8OXRM=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.13.0"
      "sha256-Ge098mg+jeOxwpBr3BMELnRD0cqZqmRSArHh/m2OsBE=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.13.0"
      "sha256-hf5aYWELJQniMsldhHv25/2Rqk3SnSGbJ0OBsdDO/us=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.13.0"
      "sha256-T784XUsVCpZKSfl8JtrCA8zYieE7WRFUS0GjGkiMb7M=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.13.0"
      "sha256-vY8bUjfix0ooShceyA56KkI3VvTQhWQdO2KAFOQK/fs=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.13.0"
      "sha256-x7GlfEgtPacEjliok6xIqJ0wYC/AZqYDHPiGrXRmpGg=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.13.0"
      "sha256-eCf9pN4Xra2TTjes8hDFegbkmM/pz1onMS5ntJKE1E0=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.13.0"
      "sha256-VMIE+miyZDZRG9BYy/q6Y+FQngScblfnL3UKQVY0VhA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.13.0"
      "sha256-rVC6BOWbPKiivjAyqGlG1sYPwAPMDfy0puzrk+2ow+U=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.13.0"
      "sha256-XtNzPH9a+FZg6RgXuJFkkHj4utt84u/PYWpHz3fQOC8=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.13.0"
      "sha256-52y4FXYR7Hk3pjNe8Er9j94tGuLnPKx2sf+YJtyg8Sg=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.13.0"
      "sha256-GZBsVNbdQ8J936kW8UfVfOwIw9ftEttSl942pcDxr4A=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.13.0"
      "sha256-hE+juDpyRZ0zPsSGMGt037o7NLN0z7Co7m+HCKSh5Fc=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.13.0"
      "sha256-O8F7NN8hkQiDJNy8Y3Cx1w1WwUGH0y9YtGIz8Wcj1/E=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.13.0"
      "sha256-dZHvgOfBn61k6VMcFGBmBZ4BrR1TUgTPx55Rvw3+isc=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.13.0"
      "sha256-LF9SEkOMDBq2yvlQHPBx4pLByEzRtgOZS8x1btm0snc=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.13.0"
      "sha256-Bv5lSIWGbFJxpMK//ZUm8ewaf0d7XuAgZcYA1EghVtA=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.13.0"
      "sha256-5hMlJfYR8qYQg9S12xwKHxIt7Grv3F0CwUE/p0WP2ZU=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.13.0"
      "sha256-ecnz27IztSMrBt4xc4DsZbNpliciSswNIOHT3t6tTXg=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.13.0"
      "sha256-nhKOiHgIC59fwH1HTLusuTgiaOJ5KidRm9DHuGQmQnE=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.13.0"
      "sha256-FBQDcjY3tx1M3012LzP2FO/1z9WQ9xihburpWv9Tq78=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.13.0"
      "sha256-rEOkdFru0ZbjPWLvC9TlAd46r9bviqEmpKPvL0MqhjI=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.13.0"
      "sha256-0f/Nl7BqZ+AFAJrckS1DtZGl3QNWCIsJAusVgkXuTvQ=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.13.0"
      "sha256-nl6GBcrpUaBWghji5309vsHGxWuRHe8R1Z0w1OSpf2k=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.13.0"
      "sha256-EX0Wq0B/2gOhX6ekSDpWUsC57wrVPBXakf7zjLql7i0=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.13.0"
      "sha256-2YYJskPHKJJGwvfWKT3CA2XZFcJ//dSroaZj8Z3Zz/M=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.13.0"
      "sha256-TPueQ1LwzxJVM11CfA5Uy+s1wgZ4cFtFg2h9lwX/Bqk=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.13.0"
      "sha256-MrjUkjhU9spam5WRWNMNrEaUV+VDj5bLb4jEOpxSnic=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.13.0"
      "sha256-ApnELs3BVh05bLJvzFfLgbn1kY2IjItbjZh8xw90UPo=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.13.0"
      "sha256-+xPIVVF1QdCbs/yaWKlD5WHc400MwV01BJAKlau85I4=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.13.0"
      "sha256-Vc7G2TRaxerOVf+wG6T5gHqR0atMP0SdehJe+55GZZc=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.13.0"
      "sha256-os4//4oH0mvWDeA8TyuZc3WL4Zqs2blepwLx+3W/RKw=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.13.0"
      "sha256-M1j3PX0xDOwp6N2kPR2B9q0hzKZ8SlGkNlRNQHl4F3o=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.13.0"
      "sha256-i/nA25zWKIpg25TJJqKnFaudaSUjbPc7PHXtixu3rIE=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.13.0"
      "sha256-0R7Z1p9CVjtWKlhs1n4jDMDheOQXn5jrbxIGK6Hz3+A=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.13.0"
      "sha256-aLJfuoQrT10rDwqZXGdE8d5WQ5GnSwAhO3ttX4ZhdG8=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.13.0"
      "sha256-7LXp7pXpgCx083rzIeytSzoRKsI9Lry/k356/mwlWQM=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.13.0"
      "sha256-ayM9VLN9jAmJeMXWmJwa5knSIK/goX+IFP5IJyaYYN0=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.13.0"
      "sha256-gbVx6et48YFYzqqhhHg1OhhbYBCTUOv7me9mxcFEx/w=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.13.0"
      "sha256-Nm50NIyIhRJ7zy/riVNYZhGW4iJXV1BZdHukpFFQi+c=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.13.0"
      "sha256-POUIiTtEa85VA6s7FtwP8TSNdo1MNe+6IWIDDIKpFMs=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.13.0"
      "sha256-nVxbggkxC82171TDifKU7NRcohmiWdGKBbAY6cNLZkM=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.13.0"
      "sha256-rwImBaQiRyo/FMibogZwe+cuJVNkKCK05R7O6RFt1hc=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.13.0"
      "sha256-eOB6McK2F4B2c1vQmc26OsU/N8HAVtm3ZUBSZzkRyUA=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.13.0"
      "sha256-mTfRSAwyOYBk3fcPgcwilZ0o7sEB1U5msLt9AOzUNnY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.13.0"
      "sha256-JyMI0ldwLZcY20vTs5lIda2EjRhnzyJVw3/EQKkxPQs=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.13.0"
      "sha256-CAqHIVnso4h6Vw7nK3Oy1BbMxywPmHt6oaJcpCQk6GM=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.13.0"
      "sha256-MIqF9A9KPW2yzWHeEhX8usTtT92GuAEKAYf9FhjxW90=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.13.0"
      "sha256-83zr/u4Q6KhFm3Id0nY6yVAtBZhD45jWXaqRdyPftNU=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.13.0"
      "sha256-ZaQSNpRsGarE8NCcoafeRokn2HfdKApexxLwcz7rUVM=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.13.0"
      "sha256-kjxNEPAKBHsCKnJI+WgdVhEmrVURHfyUUwHOLSNazn0=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.13.0"
      "sha256-LG6cM9E5KgkMR2On3Z45UN3VgfcBtIPtBpt8OmTbhP8=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.13.0"
      "sha256-jPzcbqjrCS22zhDmrOK9KOvYv7y15iY88FSad2t9Dyc=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.13.0"
      "sha256-Mtpin8e/YS95wDCII4w4lD9KiL4jXyYbeEDEGaLb38U=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.13.0"
      "sha256-/fpb6bsagRYCil2SOWviJjdqNEMJjD7WMemzRf7C63o=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.13.0"
      "sha256-MSL3mYBrUDBeLitsWfR3Q2mwRzpoclL/oJkaFxc6TTw=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.13.0"
      "sha256-hZGqU1HI/0et9myUffbJDHFhsCkpl8x5M+iNgsxeNnk=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.13.0"
      "sha256-HD2rT2bgrFPGQQrHicz/1jnP9pbLnp+KN/kdA+Dp12U=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.13.0"
      "sha256-iXg4JDx3U42iwFVrpHHqk6yhCnHA0g9NA+f25BR85Ws=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.13.0"
      "sha256-B91QlIhMp9hGgJsToYseTQSB4n3Sgei4Bdgl3RmU5cw=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.13.0"
      "sha256-2UwHy/6Ni/6rmd+OW1FKXp2jSDueGntuVInNt2kbHR8=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.13.0"
      "sha256-L+Lo4cSR905FO7fkyFgJAhJ7JXmwpZY6yrAs3sI9Pow=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.13.0"
      "sha256-eLnheUZLKCaklJuihJbnOi/nK/4G4QWpnpz8PWRYDa0=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.13.0"
      "sha256-5r6e/tA+U8IJhX89/aQBSnEzOECDFqIoQ1t906c8p8s=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.13.0"
      "sha256-2IKR1goAmHifDr1emN4VORd9WV1rZMbfEapVc+TQ9WE=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.13.0"
      "sha256-M/B4jn9RFGHHa1xbC7JeCQdKPqC7eU2Dv8wEIH0J9jQ=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.13.0"
      "sha256-mzvCnITcMJzMfpfRQFyIVpbtfVPY4qy5OLyb3UIlqUo=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.13.0"
      "sha256-RejNbn28WmZ+ioSAKYFIegfC1AkbkRWLd65IwnWgzHY=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.13.0"
      "sha256-HR9zSE6SOLTYqQZV+RowVCV+YfVafbuCvfNvrNYUVgo=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.13.0"
      "sha256-WWfZkvq+OgnYGrTRcJfLJCZGsjpUy2AsEMkTyb+CUcs=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.13.0"
      "sha256-icVLvU1ZI1/5/owDALeg25qCK1Ny3PVrCvfydIfBCO8=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.13.0"
      "sha256-rgKjBmULUFRAFr8b6J9m58aoR2pKkSjLhJY7lkZOKRY=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.0"
      "sha256-BICpQNN+Br+iDoMeTNSNyNacVgI1OrfcyZkDBl2SoUo=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.13.0"
      "sha256-+Y1GRkcDbR4SXOIGneHepAS/qrgjnM7K26po8Nf1YsA=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.13.0"
      "sha256-s3unZa/uhHtqArgIuBNoWcTnAFj9rduODKfs6gtc2fw=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.13.0"
      "sha256-ZS8XXr4rroDTCDSuPep8kG7e/h8v9i7499UJrQfgEDk=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.13.0"
      "sha256-fvEnIIx66IrTx4exrIJm/KVytf0F+fb3RpmUVE2niXA=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.13.0"
      "sha256-R12G5XKsP034MeJ2Tf2bctcrMVlfQ6o9ZDCBpdLN/+E=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.13.0"
      "sha256-H2tj/8DQqtT1GIZP1FmRuAR/bf5Q5d1VOoCcsgsQxJA=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.13.0"
      "sha256-00Di+tYc0/CTTUOu1ax1lNp/2tfCvB58L9ETzqWEjRE=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.13.0"
      "sha256-q9sBKS2BiiuCGvv+pkm/WSgN70a/KY7gLgxayG3yu98=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.13.0"
      "sha256-bNahQYb5iuNxk+XQSpf61w68hjGA6Hm62zr70Gj2UeU=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.13.0"
      "sha256-zpvBC/rJ/7+C1JDwpiZtksC964po0TuHPBeW6yvD5ww=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.13.0"
      "sha256-E3N6ewi/YCAeoHBW5WS0FwkO5YjZURxUJhSnESWuG40=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.13.0"
      "sha256-LGOxPGYIIXqu/+4SenVUAWhpo7xiSf76wkv8RmSaWro=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.13.0"
      "sha256-inV4lalhHYvkbyIHcG3DQfAllLSW15sUYHr9b0yhg0g=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.13.0"
      "sha256-KjQ+zOmxStuXKokL3R1JfZhKwEpH/FRhfhpfz78rZw0=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.13.0"
      "sha256-LfEOIg6J72v6JBlpl5QFEuqxA28CWJCP+bkhtIvQB6c=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.13.0"
      "sha256-Ss1iKr7EUhLXTT/bSM63HX01NNuKtpKWLodVaZIfNso=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.13.0"
      "sha256-POEZh26xXi3VJWuGaWjf4r8XHL9RKdrEkpb3gqAWWOQ=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.13.0"
      "sha256-3X8YP4T3ZhW4QG9eUZDK/YEH4GrqsjlYKcajkx3EwrQ=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.13.0"
      "sha256-jk2OPWSuPMSU5N4dGhEKacjcker9fWnvKqFAB0CR71o=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.13.0"
      "sha256-ev7xOsnF0HscpYbp8P4tcHCs9NepHHWU0LCetScAlx0=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.13.0"
      "sha256-l3p0VtDiGp8FyXjDjSgiX2IjvLizx9kkv3EvJEIFNBI=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.13.0"
      "sha256-f79eCbB0RFbcNbmPFWpT830y+42QXb5+dM1WTab9cP0=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.13.0"
      "sha256-DzpcGn4lfHbUysUx2S2mcSOOTJJhYS0soEFDapYADkE=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.13.0"
      "sha256-9CUdzl8WKlgOZK6ovzTT7Kjt9/RuUiER0LAR/T1Su1Q=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.13.0"
      "sha256-57zdAVy4B/Xvr2g81zB4z7pkvrQgcCPq+AhV305OS1Y=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.13.0"
      "sha256-E6p9sQx8+NPVMXMxD8c1UdZrHYH4Qd0A80JHGFhA7ss=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.13.0"
      "sha256-aXh055/gbJJCyG5QVXpIKqw+coxVBGmhw2VPdvZnBik=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.13.0"
      "sha256-c42b0kDLfRBE+lJ7r/GUqYqj7Dl/z0aUbpg4y2XEoAU=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.13.0"
      "sha256-be+Ul5pZYU3EuBoSriRHdOECu+8FcIBu/hHsBtMSrCM=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.13.0"
      "sha256-6nulrxv3q74k1Mld1/JtGFx+EQCDuFecxskw1aZvZ3M=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.13.0"
      "sha256-dB0R/ZUIIgEyWmlvbrFxh53C3Xq92EGrObd/FiQJlOU=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.13.0"
      "sha256-Urwvd8q8FOwhYhl1oi8onuP3r1Qu3V7kCgfH7mN5t8g=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.13.0"
      "sha256-36D0kXk4qitMvkA7If8bZUUdnntEkXFeg2txUzjFzJc=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.13.0"
      "sha256-39psT/kzcSLJqP3Wy08GBZ9/4guzw/x+ndbNYuLP1ns=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.13.0"
      "sha256-15z6hK1P9LREE8ehE+SzTR6BZqUzkFLjw/x3UGuRNAw=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.13.0"
      "sha256-LlVfeu1m0FROsfyWrLcZRFU0cZivHfuLIZNbpLhXvuU=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.13.0"
      "sha256-AdwPPoUy7jnSTdnAR1w2m9b+txQagRaBUWr8/TOuTjU=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.13.0"
      "sha256-tq4SeOB2pAsw7p+zHp7l3A9rkCu8Gx9/shuYA0W3gbY=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.13.0"
      "sha256-n8y+lLePLNr0OQG8V0orUolAk25T9+zjOESwL7hzx0U=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.13.0"
      "sha256-6wjuDJGyF08s0iVFiz/ZemBxz76ZMiMBO+JBGcBhUL0=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.13.0"
      "sha256-YRCKvcxvjYvLjvh5s02A9EihxBqTsGMDgByhqbFhlmY=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.13.0"
      "sha256-w3xyGATAH0dku7XD4qBR8x4YW9n1lBkxCm45b6oZYw4=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.13.0"
      "sha256-c/74cWPIFaFqZO2/KwuBFzDRFXUN6mGEU4+dhlmZL2c=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.13.0"
      "sha256-KWIljOtiUP4vnED4jhtEK+o8KkNd5144rHrGGOFEzSo=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.13.0"
      "sha256-7TABg31imqlKbOpfhHfEsvBWiuSvXFQXBV5sy4Vypdw=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.13.0"
      "sha256-n94mli/2Ugq3wfsB7nY6xMG/w4mPnpna7nzKd8tuH9s=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.13.0"
      "sha256-TUX08CfZ+ts1c8nnUVQTXueX7A6Kv/+8gVxvIs/r1vs=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.13.0"
      "sha256-Rkys6ilXRFonXAt/w97LYfBbqASrs9pLiB79wgzIXxk=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.13.0"
      "sha256-nN6qqN6uhy0NvrubHlYjLurHZxbKqmdMMBS3GM0wcXQ=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.13.0"
      "sha256-CCG6vttkC1uj7gxRxO7xFnd35gAfhhLm5Dj7VVeJEHc=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.13.0"
      "sha256-CQUSDYfeW4Esvi3gTae4xaYZTA6ylPriWV81S6+NeNQ=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.13.0"
      "sha256-8chbPLryP96xhv2Y6mPLYnAmUp7tz1KL14EB9OED3aA=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.13.0"
      "sha256-gaFNIBWhLBXgSdvrztz702QROQbkwd0+VTAjV0zme2Q=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.13.0"
      "sha256-JvPF9T7h4Vz/9lXQ+JZr+NtmUHj2JTcpdUPq1hH9Z0Y=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.13.0"
      "sha256-cnyN8S4V+wdlhqhWLwOBlsZxL7LEXy/hPI14+xwCP1o=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.13.0"
      "sha256-xEkOqe5WtYJArHH7MIluw/ANTxo2/Yrh4XZoFW12fAM=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.13.0"
      "sha256-ENUvZw4nCFffkH2VCfTKg2gzvATLXqh+SbXdPdowJbI=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.13.0"
      "sha256-55qykWmSOXfwrZuLq6xgyPSLp+fW1k4sOm9Az8SPAls=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.13.0"
      "sha256-ZGWo0IqJls/dZp0nHCjL7kxHoqHThm0IrNH81ecaHiA=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.13.0"
      "sha256-UEmw6ehUWFpNECvB5fg9hy4MzsSUYbypb+NPwshH97I=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.13.0"
      "sha256-0gSeq5TGWisG+7juOwMikhMcZRyVj1K996sHUuQJhJg=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.13.0"
      "sha256-BhDbkVmqNNw3thOA7dDBf2wsGsOYnT5jsgXvMiQlSp4=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.13.0"
      "sha256-bPXKu5HDDvU9wPb5Av6n2C1sszO1zAfC395oC1x11yA=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.13.0"
      "sha256-1mXX7egH6VDSUPnxmSAeBUm4tqh9CS+tDjdu+j/tPWo=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.13.0"
      "sha256-wt0NAOC+pb6XTD59ZNLksByX4FwAmrQ2HErj15FUA2E=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.13.0"
      "sha256-csZFZFJwaxrWFmhzQjdw7DHfTxdfEt41GUh2OQ52wkg=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.13.0"
      "sha256-WAPagWtRhqsmwrCXGNTai/uargonI8p9PMx6ER3gUus=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.13.0"
      "sha256-AjAj8QHxU0aOqWMt98M+Qe5v6Dc72ftWuaQ7omTlkRg=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.13.0"
      "sha256-liVnb5YGMACt8P3NXYudpY8Ai5bVqZuv3Q0/WNrLCHg=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.13.0"
      "sha256-Yl/GGw/5EUPuIsPUbrG+g1icYqlewsFLwFdvUCnrT4E=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.13.0"
      "sha256-v0mr8Z2VMpMzPVbnxCoGJ4Oc2Az2QI3Emnci4UMe6sc=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.13.0"
      "sha256-lwsfWc2pkCpsX84z1CfwbWjORqwv+ULpe96Gl4063Fk=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.13.0"
      "sha256-viS9OU1nyW8tk4c0G4oWh48APJf39s/P2Vqo2iLJXbg=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.13.0"
      "sha256-09grClFgCl+HJX5jmttq7y1HRDuBIn0z16dHO4iRmB4=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.13.0"
      "sha256-IKxnbv5AnPFS2MnkruYX3BsQTwrj/dnWhDURTD1/rcU=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.13.0"
      "sha256-VhxY09Y/GdngzaNQClwDBxrIsxGGUPnUfhnIEmoFa08=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.13.0"
      "sha256-TCuTVU3ibRuJxqo0YofFDHkKhsqPErqdSIEks1lFGxE=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.13.0"
      "sha256-22jlffIHiNjCGc7Vfz5HhLPrquy/3qTB2MRtjOvKHkk=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.13.0"
      "sha256-4pjWdJ2/5iUM6YOs8lhApi0zDFnsrt9Nja3W59sNZpw=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.13.0"
      "sha256-Cfmcdmx6SjcL+26o1T6yyC/KDYBx/B0jn4wYZizWTuw=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.13.0"
      "sha256-7fo5XF4RMTKWHqDknStr/3T++TCDJvkxXGTw8l2y3n8=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.13.0"
      "sha256-Z7q+pNHlTSyagYUkCIQwsOgNousT7s7VnNEyGqi9LqM=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.13.0"
      "sha256-+0aYuQO2nN1nyNFwSL1Fh/CWfLWkb7tu2ZAPtwG5vxw=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.13.0"
      "sha256-K+l4X7/2e4iv1kip9iPZUj22/HsJhhQGZ0H7rUHg/5g=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.13.0"
      "sha256-6j+YcV4oEB5rZ6k2+Jlzn0irZCd5f1tIIASjKFNkMx4=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.13.0"
      "sha256-gWuBHbxl8UkEUL2FQ/Gfb1rKmFNHrON72Bo1lxRbwYU=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.13.0"
      "sha256-gpaamDvztO5syi72/O721Li1YUmjnWbsT2fxTi8TfKQ=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.13.0"
      "sha256-39J795V0hlag4UXJPL95hwp/nvYsRKrrFfCA/DSh4Dk=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.13.0"
      "sha256-/rlkm98WGctndpPkt1ffkeK1+EVBecwouhTK2ycdenU=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.13.0"
      "sha256-Mw6f1xt421x+gA/pmhD9XXDMAIKsDG/oN8/wBVnaRxw=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.13.0"
      "sha256-lSwXwyKhLxHwAV8Qdkq0IlDg6UnhlBBjFJthHjSv4TY=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.13.0"
      "sha256-O4f9e6TkSssRfRW1DWRabocBjElEPyZNbZQwKiGtEmM=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.13.0"
      "sha256-m9FxXdOGc4VrM552FB1QIpLnX0dIT+wcK7zWyXLqCm4=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.13.0"
      "sha256-biwuRY/iWsjeX61+TXeFmiUbxjPpCuSCrFXXcvwQFW4=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.13.0"
      "sha256-8K0aNHqTSthROSsUNjoUqeqlkW5ieJx5tjngkNZ+aPY=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.13.0"
      "sha256-cHmk1b0IOwKUKq+QWj6BtkVj1sUI2goELu+uOG1WSX4=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.13.0"
      "sha256-MFlLufnrOZuVEz0X4saMIZ6NOmoOZz4ErhGu2qmIU+M=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.13.0"
      "sha256-NQpTnbyABcbdDOiqNowjyp8eE1FHiiNBP3WfzQuvIWU=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.13.0"
      "sha256-l6LidYUiTrHzuCLlLAU+8XHHpMjy6csClPvGOf7o8Zk=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.13.0"
      "sha256-6Y2NJj3bs88agfiUEzMgl/1Zkci45hoVtNIClzcar/Q=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.13.0"
      "sha256-awkyq4V50G0l5epg1BFD54kMXEYrHe8iso8zlrobvF8=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.13.0"
      "sha256-CIAMqHhr0E0SFz9IyS2fOn/44Xi8oo0WPvVKNsByTfo=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.13.0"
      "sha256-1jMVFO/QbT+hh+jYt42E9DWV4uIoamdG5NjqdkOqovI=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.13.0"
      "sha256-qqgWwtB+7ZvjfQP5JOUrszNtZTDXf44Lb2jrnpQAxmM=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.13.0"
      "sha256-9FxDlKjBAlhb+Nu1d3A8AGyvaFXk6ejQI2b7f47SguQ=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.13.0"
      "sha256-yrloTL8MYnHkeVEF2Bp8i2QQ3Yh0IRGiY/VGih41lJQ=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.13.0"
      "sha256-Ln5KwCFTs+7T/ONaVj9TeBmSxsOCxXdUokiCa83ozzg=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.13.0"
      "sha256-IFlZRCvhK1vZSB4uHwPa1CP678E8UboL4geqHHivrg4=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.13.0"
      "sha256-IouagvvqSdfFQ5ZryCukEBXSryTHxT34z4aQu4vG/E4=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.13.0"
      "sha256-Th2TUSe1gS/hvUEP8UOx3Yxyse7JEtccznZB4TSDlxQ=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.13.0"
      "sha256-rgjP4mUyhAa8hqnsR+EkNHY4U58Vd90xOcj/WZT3Q1E=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.13.0"
      "sha256-4ECIbOcUc7DlARzgd+mE0bFr8QDVrpW2ZmMWiFDmIu0=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.13.0"
      "sha256-H4kG7rpxijqag14yZmNYmSxdSkRcAQw3tD/EVglkMJc=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.13.0"
      "sha256-1W4gNPVBvTCSZiC12iymw2LBRwr7i2MlimBStcjinRY=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.13.0"
      "sha256-xRQlOmoSW0w1L/jvS5aUkh3+mwCFMDem4MR8GmXTLDk=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.13.0"
      "sha256-AE1njAVbSJZf2Ce5ra6ARUnqOb/FKQpA8mN2TpFiwJ4=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.13.0"
      "sha256-gwk2sUPHH7+k4NcHXMmnSV2lDVZbgZcTJZY8QScoQhY=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.13.0"
      "sha256-kLp8W+KROrwxNC4hgD41EVtjQuw+CPjgbbz2vFec8Us=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.13.0"
      "sha256-kcFiysNx0GmHJdhgiuAcNWX+WM7p6410oxv11d6nAi8=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.13.0"
      "sha256-du7dFEEWnVCZKIOK63SxyakQRXGqqBWUhRPQ7hcsvPo=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.13.0"
      "sha256-OtL2BuB9ORvHBjbkgTRcnwyt8g5hml/eIR3JZh5XAE0=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.13.0"
      "sha256-qCxrMdw7XIUfBnpkUP6CuV3qzaJIDGNEHynh38VxH/c=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.13.0"
      "sha256-hP+dRmyRoNOyUXLOtZk92glo80ZJ5RL98++8BWv4dPk=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.13.0"
      "sha256-no1EEOjNvuRNXlWnOxIQ7ULXyfPzIEAFLfaIDRt4/gg=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.13.0"
      "sha256-Uq7grT2EwFiVvBQNlSFIn00A/gN2Co3DU4fYsW0Bc6U=";
}
